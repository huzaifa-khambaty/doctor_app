import '../../../../exports.dart'; // Retained your custom export layer

class AppMultipleImagePickerSheet extends StatelessWidget {
  const AppMultipleImagePickerSheet._({
    required this.onSuccess, 
    this.onError,
  });

  // 1. Updated callback signature to pass an array list of selected file instances
  final void Function(List<File> files) onSuccess;
  final void Function(String error)? onError;

  // ─── Entry point ──────────────────────────────────────────────────────────

  static Future<void> show(
    BuildContext context, {
    required void Function(List<File> files) onSuccess,
    void Function(String error)? onError,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AppMultipleImagePickerSheet._(
        onSuccess: onSuccess, 
        onError: onError,
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Process multi-selection images or fallback arrays safely
  void _handleMultiplePick(BuildContext context, ImagePickResult result) {
    if (context.mounted) Navigator.of(context).pop();

    if (result.isSuccess && result.files != null && result.files!.isNotEmpty) {
      onSuccess(result.files!);
    } else if (result.isSuccess && result.file != null) {
      // Graceful fallback single conversion case if service maps arrays directly
      onSuccess([result.file!]);
    } else if (result.error != null) {
      onError?.call(result.error!);
    }
  }

  Future<void> _pickCamera(BuildContext context) async {
    // Note: Camera typically takes one single capture per invocation cycle
    final result = await locator<ImagePickerService>().pickFromCamera();
    if (context.mounted) _handleMultiplePick(context, result);
  }

  Future<void> _pickMultiGallery(BuildContext context) async {
    // 2. Bound invocation mapping to support multiple multi-image picker actions
    final result = await locator<ImagePickerService>().pickMultipleFromGallery();
    if (context.mounted) _handleMultiplePick(context, result);
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isWide ? 480 : double.infinity),
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),

              // ── Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: AppText.medium(
                  label: 'Select Images',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 8),

              // ── Options
              _PickerOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take a Photo',
                subtitle: 'Capture a single photo',
                iconColor: AppColors.primary,
                onTap: () => _pickCamera(context),
              ),

              _PickerOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose Multiple from Gallery',
                subtitle: 'Select one or more images',
                iconColor: AppColors.primary,
                onTap: () => _pickMultiGallery(context),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 8),

              // ── Cancel
              _PickerOption(
                icon: Icons.close_rounded,
                label: 'Cancel',
                iconColor: AppColors.error,
                onTap: () => Navigator.of(context).pop(),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Private tile widget ──────────────────────────────────────────────────────

class _PickerOption extends StatelessWidget {
  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.iconColor,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.medium(label: label, fontWeight: FontWeight.w600),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      AppText.small(
                        label: subtitle!,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}