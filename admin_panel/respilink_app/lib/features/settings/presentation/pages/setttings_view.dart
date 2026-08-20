import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:respilink_app/core/network/api_endpoints.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/snackbar_util.dart';
import 'package:respilink_app/features/settings/data/model/app_settings_model.dart';
import 'package:respilink_app/features/settings/data/model/requests/update_settings_request.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:respilink_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/injections.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';
import 'package:respilink_app/shared/widgets/app_skeleton.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key, this.onNavigateToDashboard});

  final VoidCallback? onNavigateToDashboard;

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  late final SettingsBloc _bloc;

  final _appNameCtrl = TextEditingController();
  final _appEmailCtrl = TextEditingController();

  String _selectedTimezone = 'EST';
  String _selectedLanguage = 'en';

  bool _dataPopulated = false;

  Uint8List? _logoBytes;
  String? _logoName;

  static const _timezones = ['EST'];
  static const _languages = ['en'];
  static const _timezoneLabels = {
    'EST': 'EST (Eastern Standard Time)',
  };
  static const _languageLabels = {
    'en': 'English',
  };

  @override
  void initState() {
    super.initState();
    _bloc = locator<SettingsBloc>();
    _bloc.add(FetchSettingsRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    _appNameCtrl.dispose();
    _appEmailCtrl.dispose();
    super.dispose();
  }

  void _populate(AppSettingsModel s) {
    _appNameCtrl.text = s.appName ?? '';
    _appEmailCtrl.text = s.appEmail ?? '';
    if (s.appName != null && s.appName!.isNotEmpty) {
      GlobalNotifiers.appNameNotifier.value = s.appName;
    }
    if (s.appLogo != null && s.appLogo!.isNotEmpty) {
      GlobalNotifiers.appLogoNotifier.value = s.appLogo!.startsWith('http')
          ? s.appLogo!
          : '${ApiEndpoints.imageUrl}${s.appLogo!}';
    }
    if (s.timeZone != null && _timezones.contains(s.timeZone)) {
      _selectedTimezone = s.timeZone!;
    }
    if (s.language != null && _languages.contains(s.language)) {
      _selectedLanguage = s.language!;
    }
    setState(() {});
  }

  void _discard(AppSettingsModel? s) {
    if (s != null) _populate(s);
    setState(() => _logoBytes = null);
    widget.onNavigateToDashboard?.call();
  }

  void _save() {
    _bloc.add(UpdateSettingsRequested(
      UpdateSettingsRequest(
        appName: _appNameCtrl.text.trim(),
        appEmail: _appEmailCtrl.text.trim(),
        timeZone: _selectedTimezone,
        language: _selectedLanguage,
        logoBytes: _logoBytes,
        logoName: _logoName,
      ),
    ));
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _logoBytes = result.files.single.bytes;
        _logoName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: _bloc,
      listenWhen: (prev, curr) =>
          prev.saveSettingsSuccess != curr.saveSettingsSuccess ||
          prev.isLoadingSettings != curr.isLoadingSettings ||
          prev.isSavingSettings != curr.isSavingSettings ||
          prev.error != curr.error,
      listener: (context, state) {
        if (!_dataPopulated && state.appSettings != null && !state.isLoadingSettings) {
          _dataPopulated = true;
          _populate(state.appSettings!);
        }
        if (state.saveSettingsSuccess) {
          setState(() => _logoBytes = null);
          final savedName = _appNameCtrl.text.trim();
          if (savedName.isNotEmpty) GlobalNotifiers.appNameNotifier.value = savedName;
          final logo = state.appSettings?.appLogo;
          if (logo != null && logo.isNotEmpty) {
            GlobalNotifiers.appLogoNotifier.value = logo.startsWith('http')
                ? logo
                : '${ApiEndpoints.imageUrl}$logo';
          }
          SnackbarUtil.showSnackbar(context, message: 'Settings saved successfully');
        }
        if (state.error != null && !state.isLoadingSettings && !state.isSavingSettings) {
          SnackbarUtil.showSnackbar(context, message: state.error!, isError: true);
        }
      },
      builder: (context, state) {
        final showShimmer = state.isLoadingSettings && state.appSettings == null;
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumbs
                Row(
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted.withValues(alpha: 0.8),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24),

                if (showShimmer) ...[
                  _SettingsShimmer(),
                ] else ...[
                  // Platform Identity Card
                  Container(
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
                        const Text(
                          'Platform Identity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Global branding and support information for the platform.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 600;
                            return Flex(
                              direction: isCompact ? Axis.vertical : Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: isCompact ? 0 : 1,
                                  child: _buildTextFieldBlock(
                                    label: 'App Name',
                                    controller: _appNameCtrl,
                                  ),
                                ),
                                SizedBox(
                                  width: isCompact ? 0 : 16,
                                  height: isCompact ? 16 : 0,
                                ),
                                Expanded(
                                  flex: isCompact ? 0 : 1,
                                  child: _buildTextFieldBlock(
                                    label: 'Support Email',
                                    controller: _appEmailCtrl,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Logo Upload',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildLogoArea(state.appSettings?.appLogo),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Regional Settings Card
                  Container(
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
                        const Text(
                          'Regional Settings',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Set localized formats and languages for the admin interface.',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 600;
                            return Flex(
                              direction: isCompact ? Axis.vertical : Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: isCompact ? 0 : 1,
                                  child: _buildDropdownFieldBlock(
                                    label: 'Default Timezone',
                                    value: _selectedTimezone,
                                    items: _timezones,
                                    labelOf: (v) => _timezoneLabels[v] ?? v,
                                    onChanged: (val) =>
                                        setState(() => _selectedTimezone = val!),
                                  ),
                                ),
                                SizedBox(
                                  width: isCompact ? 0 : 16,
                                  height: isCompact ? 16 : 0,
                                ),
                                Expanded(
                                  flex: isCompact ? 0 : 1,
                                  child: _buildDropdownFieldBlock(
                                    label: 'Language',
                                    value: _selectedLanguage,
                                    items: _languages,
                                    labelOf: (v) => _languageLabels[v] ?? v,
                                    onChanged: (val) =>
                                        setState(() => _selectedLanguage = val!),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Footer actions
                  Row(
                    children: [
                      const Spacer(),
                      OutlinedButton(
                        onPressed: state.isSavingSettings
                            ? null
                            : () => _discard(state.appSettings),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Discard Changes',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: state.isSavingSettings ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF009688),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: state.isSavingSettings
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFieldBlock({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 42,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFieldBlock({
    required String label,
    required String value,
    required List<String> items,
    required String Function(String) labelOf,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.textMuted,
              ),
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              onChanged: onChanged,
              items: items
                  .map((v) => DropdownMenuItem(value: v, child: Text(labelOf(v))))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoArea(String? existingLogoUrl) {
    if (_logoBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            GestureDetector(
              onTap: _pickLogo,
              child: Image.memory(_logoBytes!, height: 120, fit: BoxFit.contain),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => setState(() => _logoBytes = null),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (existingLogoUrl != null && existingLogoUrl.isNotEmpty) {
      return GestureDetector(
        onTap: _pickLogo,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AppNetworkImage(
            imageUrl: "${ApiEndpoints.imageUrl}$existingLogoUrl",
            height: 120,
            fit: BoxFit.contain,
            errorWidget: _dashedUploadArea(),
          ),
        ),
      );
    }

    return _dashedUploadArea();
  }

  Widget _dashedUploadArea() {
    return GestureDetector(
      onTap: _pickLogo,
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: const Color(0xFFCBD5E1),
          strokeWidth: 1.2,
          gap: 4.0,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 28, color: AppColors.primary),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(text: 'Drop files here or '),
                    TextSpan(
                      text: 'click to upload',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SVG, PNG, or JPG (max 2MB)',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSkeleton.textBar(width: 140, height: 16),
              const SizedBox(height: 8),
              const AppSkeleton.textBar(width: 260, height: 12),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppSkeleton.textBar(width: 70, height: 12),
                        const SizedBox(height: 8),
                        const AppSkeleton(width: double.infinity, height: 42),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppSkeleton.textBar(width: 90, height: 12),
                        const SizedBox(height: 8),
                        const AppSkeleton(width: double.infinity, height: 42),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const AppSkeleton.textBar(width: 80, height: 12),
              const SizedBox(height: 8),
              const AppSkeleton(width: double.infinity, height: 120),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSkeleton.textBar(width: 140, height: 16),
              const SizedBox(height: 8),
              const AppSkeleton.textBar(width: 300, height: 12),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppSkeleton.textBar(width: 110, height: 12),
                        const SizedBox(height: 8),
                        const AppSkeleton(width: double.infinity, height: 42),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppSkeleton.textBar(width: 70, height: 12),
                        const SizedBox(height: 8),
                        const AppSkeleton(width: double.infinity, height: 42),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const AppSkeleton(width: 130, height: 44),
            const SizedBox(width: 12),
            const AppSkeleton(width: 120, height: 44),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: child,
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    final path = Path()..addRRect(rrect);
    final metricsPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        metricsPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap + gap;
      }
    }
    canvas.drawPath(metricsPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
