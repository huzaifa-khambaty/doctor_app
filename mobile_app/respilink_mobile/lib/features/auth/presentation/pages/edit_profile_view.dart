import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_mobile/core/network/api_endpoints.dart';
import 'package:respilink_mobile/core/utils/global_notifiers.dart';
import 'package:respilink_mobile/core/utils/handlers.dart';
import 'package:respilink_mobile/core/validators/validators.dart';
import 'package:respilink_mobile/features/auth/data/models/requests/edit_profile_request.dart';
import 'package:respilink_mobile/features/auth/data/models/specialities_model.dart';
import 'package:respilink_mobile/features/auth/domain/models/user_model.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:respilink_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:respilink_mobile/shared/widgets/app_loader.dart';

import '../../../../exports.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _hospitalCtrl;

  List<SpecialitiesModel> _specialities = [];

  /// Staged locally until "Save Changes" is tapped — uploaded together with
  /// the rest of the form in a single multipart request.
  File? _pickedImage;

  Doctor? get _user => GlobalNotifiers.userNotifier.value;

  Set<int> get _userSpecialtyIds =>
      _user?.specialties?.map((e) => e.id).whereType<int>().toSet() ?? {};

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.fullName);
    _phoneCtrl = TextEditingController(text: _user?.phone);
    _hospitalCtrl = TextEditingController(text: _user?.hospitalAffiliation);
    context.read<AuthBloc>().add(SpecialitiesRequested());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _hospitalCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final hospital = _hospitalCtrl.text.trim();
    final request = EditProfileRequest(
      fullName: _nameCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      hospitalAffiliation: hospital.isEmpty ? null : hospital,
      profilePicture: _pickedImage,
    );

    BlocProvider.of<AuthBloc>(context).add(UpdateProfileEvent(request: request));
  }

  void _changeAvatar(BuildContext context) {
    AppImagePickerSheet.show(
      context,
      onSuccess: (file) => setState(() => _pickedImage = file),
      onError: (error) => SnackbarUtil.showSnackbar(message: error, isError: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Handlers.onProfileUpdated(state.model);
        } else if (state is AuthFailed) {
          SnackbarUtil.showSnackbar(message: state.message, isError: true);
        } else if (state is SpecialitiesLoaded) {
          setState(() => _specialities = state.specialities);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.black),
            title: AppText.medium(
              label: 'Personal Information',
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// Avatar + intro
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _buildAvatar(),
                              Positioned(
                                bottom: -2.h,
                                right: -2.w,
                                child: GestureDetector(
                                  onTap: () => _changeAvatar(context),
                                  child: Container(
                                    padding: EdgeInsets.all(6.r),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                      border: Border.all(
                                        color: AppColors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.white,
                                      size: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          AppText.small(
                            label: 'Update your personal & contact details.',
                            color: AppColors.grey,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Editable fields card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.fieldColor,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.small(
                            label: 'FULL NAME',
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 6.h),
                          AppFormField.filled(
                            controller: _nameCtrl,
                            hint: 'e.g. Dr. Sarah Jenkins',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              size: 20.sp,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? Validators.fullNameRequired
                                : null,
                          ),

                          SizedBox(height: 16.h),

                          AppText.small(
                            label: 'PHONE NUMBER',
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 6.h),
                          AppFormField.filled(
                            controller: _phoneCtrl,
                            hint: '+1 (555) 000-0000',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              size: 20.sp,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? Validators.phoneRequired
                                : null,
                          ),

                          SizedBox(height: 16.h),

                          AppText.small(
                            label: 'HOSPITAL AFFILIATION',
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 6.h),
                          AppFormField.filled(
                            controller: _hospitalCtrl,
                            hint: 'Mayo Clinic, Rochester',
                            prefixIcon: Icon(
                              Icons.local_hospital_outlined,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// Read-only account details
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.fieldColor,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.small(
                            label: 'ACCOUNT DETAILS',
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 10.h),
                          _ReadOnlyRow(
                            icon: Icons.mail_outline,
                            label: 'Email Address',
                            value: _user?.email ?? '-',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// Specialties (view-only — highlights the user's own)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.fieldColor,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.medical_services_outlined,
                                color: AppColors.primary,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              AppText.small(
                                label: 'SPECIALTIES',
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (_specialities.isEmpty)
                            AppText.small(
                              label:
                                  _userSpecialtyIds.isEmpty
                                      ? 'No specialties on record.'
                                      : _user!.specialties!
                                          .map((e) => e.name)
                                          .whereType<String>()
                                          .join(', '),
                              color: AppColors.grey,
                            )
                          else
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: _specialities.map((speciality) {
                                final isMine = _userSpecialtyIds.contains(
                                  speciality.id,
                                );
                                return FilterChip(
                                  label: Text(speciality.name ?? ''),
                                  selected: isMine,
                                  onSelected: null,
                                  selectedColor: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  checkmarkColor: AppColors.primary,
                                  disabledColor: AppColors.white,
                                  labelStyle: TextStyle(
                                    color: isMine
                                        ? AppColors.primary
                                        : AppColors.grey,
                                    fontWeight: isMine
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  side: BorderSide(
                                    color: isMine
                                        ? AppColors.primary.withValues(
                                            alpha: 0.4,
                                          )
                                        : AppColors.grey.withValues(
                                            alpha: 0.3,
                                          ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    state is AuthLoading
                        ? AppLoader()
                        : AppButton.filled(
                            label: 'Save Changes',
                            onTap: () => _submit(context),
                          ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    if (_pickedImage != null) {
      return ClipOval(
        child: Image.file(
          _pickedImage!,
          width: 80.r,
          height: 80.r,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_user?.profilePhotoPath != null) {
      return AppNetworkImage(
        imageUrl: "${ApiEndpoints.imageUrl}/${_user!.profilePhotoPath}",
        width: 80.r,
        height: 80.r,
        isCircle: true,
      );
    }

    return CircleAvatar(
      radius: 40.r,
      backgroundColor: AppColors.fieldColor,
      child: Icon(Icons.person, color: AppColors.grey, size: 40.sp),
    );
  }
}

class _ReadOnlyRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ReadOnlyRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 18.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.small(
                label: label,
                color: AppColors.grey,
                fontSize: 11.sp,
              ),
              SizedBox(height: 2.h),
              AppText.medium(
                label: value,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
