import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/features/practioner/data/model/specialities_model.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_bloc.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_event.dart';
import 'package:respilink_app/features/practioner/presentation/bloc/practioner_state.dart';
import 'package:respilink_app/service/image_picker_service.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';

class ManualEnrollmentContent extends StatefulWidget {
  final VoidCallback onBackToUserManagement;

  const ManualEnrollmentContent({
    super.key,
    required this.onBackToUserManagement,
  });

  @override
  State<ManualEnrollmentContent> createState() =>
      _ManualEnrollmentContentState();
}

class _ManualEnrollmentContentState extends State<ManualEnrollmentContent> {
  Uint8List? _profileImage;
  final List<SpecialitiesModel> _selectedSpecialties = [];

  @override
  void initState() {
    super.initState();
    context.read<PractionerBloc>().add(FetchSpecialtiesRequested());
  }

  void _toggleSpecialty(SpecialitiesModel s) {
    setState(() {
      if (_selectedSpecialties.any((x) => x.id == s.id)) {
        _selectedSpecialties.removeWhere((x) => x.id == s.id);
      } else {
        _selectedSpecialties.add(s);
      }
    });
  }

  Future<void> _showSpecialtyDialog(List<SpecialitiesModel> available) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _SpecialtyPickerDialog(
        available: available,
        selected: _selectedSpecialties,
        onToggle: (s) {
          _toggleSpecialty(s);
        },
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration(String hint) => InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        );

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header Actions bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Manual Practitioner Enrollment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Onboard new medical staff manually into the RespiLink system.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: widget.onBackToUserManagement,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: AppColors.textDark,
                  ),
                  label: const Text(
                    'Back to User Management',
                    style:
                        TextStyle(color: AppColors.textDark, fontSize: 13),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.borderLight),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 2. Section Card: Personal Information
            _FormSectionCard(
              title: 'Personal Information',
              icon: Icons.person_outline_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo Uploader Row
                  Row(
                    children: [
                      _profileImage != null
                          ? AppNetworkImage(
                              bytes: _profileImage,
                              height: 80,
                              width: 80,
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  final image = await ImagePickerService
                                      .instance
                                      .pickFromGallery();
                                  if (image.isSuccess) {
                                    setState(() {
                                      _profileImage = image.image?.bytes;
                                    });
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 20,
                                      color: AppColors.textMuted
                                          .withValues(alpha: 0.8),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'UPLOAD PHOTO',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textMuted,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Recommended: 400×400px JPG or PNG. This photo will be visible to patients and colleagues.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ResponsiveFormGrid(
                    children: [
                      _FieldWrapper(
                        label: 'Full Name',
                        child: TextField(
                          decoration:
                              inputDecoration('Dr. Jane Smith'),
                        ),
                      ),
                      _FieldWrapper(
                        label: 'Email Address',
                        child: TextField(
                          decoration: inputDecoration(
                            'jane.smith@hospital.org',
                          ),
                        ),
                      ),
                      _FieldWrapper(
                        label: 'Phone Number',
                        child: TextField(
                          decoration:
                              inputDecoration('+1 (555) 000-0000'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Section Card: Professional Credentials
            _FormSectionCard(
              title: 'Professional Credentials',
              icon: Icons.gpp_good_outlined,
              child: _ResponsiveFormGrid(
                children: [
                  // Medical Specialty — multi-select from API
                  _FieldWrapper(
                    label: 'Medical Specialty',
                    child: BlocBuilder<PractionerBloc, PractionerState>(
                      builder: (context, state) {
                        return _SpecialtyMultiSelectField(
                          selected: _selectedSpecialties,
                          isLoading: state.isLoadingSpecialties,
                          onTap: state.isLoadingSpecialties
                              ? null
                              : () => _showSpecialtyDialog(
                                    state.specialties,
                                  ),
                          onRemove: _toggleSpecialty,
                        );
                      },
                    ),
                  ),
                  _FieldWrapper(
                    label: 'License Number',
                    child: TextField(
                        decoration:
                            inputDecoration('MD-98234-X')),
                  ),
                  _FieldWrapper(
                    label: 'Hospital / Clinic Affiliation',
                    child: TextField(
                      decoration: inputDecoration(
                        'Central City General Hospital',
                      ),
                    ),
                  ),
                  _FieldWrapper(
                    label: 'Year of Registration',
                    child:
                        TextField(decoration: inputDecoration('2020')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 4. Submit Actions Button Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onBackToUserManagement,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save & Onboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Specialty Multi-Select Field
// =========================================================================

class _SpecialtyMultiSelectField extends StatelessWidget {
  final List<SpecialitiesModel> selected;
  final bool isLoading;
  final VoidCallback? onTap;
  final void Function(SpecialitiesModel) onRemove;

  const _SpecialtyMultiSelectField({
    required this.selected,
    required this.isLoading,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  ),
                ),
              )
            : selected.isEmpty
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select specialties...',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.textMuted),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 20, color: AppColors.textMuted),
                    ],
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...selected.map((s) => _SpecialtyChip(
                            label: s.name ?? '—',
                            onRemove: () => onRemove(s),
                          )),
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withValues(
                                    alpha: 0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add,
                                  size: 12, color: AppColors.primary),
                              SizedBox(width: 3),
                              Text('Add',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SpecialtyChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 13, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// Specialty Picker Dialog
// =========================================================================

class _SpecialtyPickerDialog extends StatefulWidget {
  final List<SpecialitiesModel> available;
  final List<SpecialitiesModel> selected;
  final void Function(SpecialitiesModel) onToggle;

  const _SpecialtyPickerDialog({
    required this.available,
    required this.selected,
    required this.onToggle,
  });

  @override
  State<_SpecialtyPickerDialog> createState() =>
      _SpecialtyPickerDialogState();
}

class _SpecialtyPickerDialogState extends State<_SpecialtyPickerDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSelected(SpecialitiesModel s) =>
      widget.selected.any((x) => x.id == s.id);

  @override
  Widget build(BuildContext context) {
    final filtered = widget.available.where((s) {
      if (_query.isEmpty) return true;
      return (s.name ?? '').toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  const Text(
                    'Select Specialties',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark),
                  ),
                  const Spacer(),
                  if (widget.selected.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.selected.length} selected',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search specialties...',
                  hintStyle: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search,
                      size: 16, color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.scaffoldBg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.borderLight, height: 1),

            // List
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('No specialties found',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textMuted)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        final selected = _isSelected(s);
                        return InkWell(
                          onTap: () {
                            widget.onToggle(s);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    s.name ?? '—',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.textDark,
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.borderLight,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: selected
                                      ? const Icon(Icons.check,
                                          size: 14, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const Divider(color: AppColors.borderLight, height: 1),

            // Done button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Done',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// Layout Helper Widgets
// =========================================================================

class _FormSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FormSectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ResponsiveFormGrid extends StatelessWidget {
  final List<Widget> children;
  const _ResponsiveFormGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: children.map((w) {
              return SizedBox(
                width: (constraints.maxWidth - 16) / 2,
                child: w,
              );
            }).toList(),
          );
        }
        return Column(
          children: children
              .map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: w,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _FieldWrapper extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldWrapper({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
