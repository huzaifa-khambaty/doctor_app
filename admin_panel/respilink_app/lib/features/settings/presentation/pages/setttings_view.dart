import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool _maintenanceStatus = false;
  String _selectedTimezone = 'EST (Eastern Standard Time)';
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Breadcrumbs Header Layout Row
            Row(
              children: [
                Text('Admin', style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                ),
                const Text('Settings', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 24),
      
            // 2. Platform Identity Form Card Box
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
                  const Text('Platform Identity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text('Global branding and support information for the RespiLink platform.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 20),
                  
                  // Form Entry Split Double Row Input Layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isCompact = constraints.maxWidth < 600;
                      return Flex(
                        direction: isCompact ? Axis.vertical : Axis.horizontal,
                        children: [
                          Expanded(
                            flex: isCompact ? 0 : 1,
                            child: _buildTextFieldBlock(label: 'App Name', initialValue: 'RespiLink Admin'),
                          ),
                          SizedBox(width: isCompact ? 0 : 16, height: isCompact ? 16 : 0),
                          Expanded(
                            flex: isCompact ? 0 : 1,
                            child: _buildTextFieldBlock(label: 'Support Email', initialValue: 'support@respilink.org'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
      
                  // Custom Asset File Attachment Target Window
                  const Text('Logo Upload', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  _buildDashedUploadArea(),
                ],
              ),
            ),
            const SizedBox(height: 20),
      
            // 3. Regional Configuration Block Panel Card
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
                  const Text('Regional Settings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text('Set localized formats and languages for the admin interface.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 20),
      
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isCompact = constraints.maxWidth < 600;
                      return Flex(
                        direction: isCompact ? Axis.vertical : Axis.horizontal,
                        children: [
                          Expanded(
                            flex: isCompact ? 0 : 1,
                            child: _buildDropdownFieldBlock(
                              label: 'Default Timezone',
                              value: _selectedTimezone,
                              items: ['EST (Eastern Standard Time)', 'PST (Pacific Standard Time)', 'GMT (Greenwich Mean Time)'],
                              onChanged: (val) => setState(() => _selectedTimezone = val!),
                            ),
                          ),
                          SizedBox(width: isCompact ? 0 : 16, height: isCompact ? 16 : 0),
                          Expanded(
                            flex: isCompact ? 0 : 1,
                            child: _buildDropdownFieldBlock(
                              label: 'Language',
                              value: _selectedLanguage,
                              items: ['English', 'Spanish', 'French', 'German'],
                              onChanged: (val) => setState(() => _selectedLanguage = val!),
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
      
            // 4. Maintenance Security Status Banner Zone
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFEE2E2)), // Subtle red stroke alert container bounds
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFEF4444)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Maintenance Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF991B1B))),
                            const SizedBox(height: 4),
                            Text(
                              'Activating maintenance mode will prevent all non-admin users from accessing the platform. Use this only for critical updates.',
                              style: TextStyle(fontSize: 13, color: const Color(0xFF991B1B).withValues(alpha: 0.85), height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Enable Maintenance Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        Switch.adaptive(
                          value: _maintenanceStatus,
                          activeThumbColor: AppColors.primary,
                          onChanged: (bool val) {
                            setState(() => _maintenanceStatus = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
      
            // 5. System Form Actions Commit Footer Bar
            Row(
              children: [
                Text(
                  'Last saved: Today at 09:42 AM',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Discard Changes', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009688), // Bright production palette color tone matching save button
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Text Entry Layout Creator Widget Model
  Widget _buildTextFieldBlock({required String label, required String initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 8),
        SizedBox(
          height: 42,
          child: TextFormField(
            initialValue: initialValue,
            style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
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

  // Segment Selection Dropdown Layer Creator Blueprint
  Widget _buildDropdownFieldBlock({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark)),
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
              icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
              style: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Simulated Dash Line Border Canvas Block Element Box Render Frame
  Widget _buildDashedUploadArea() {
    return CustomPaint(
      painter: _DashedRectPainter(color: const Color(0xFFCBD5E1), strokeWidth: 1.2, gap: 4.0),
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
                style: TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.3),
                children: [
                  TextSpan(text: 'Drop files here or ', style: TextStyle(color: Color(0xFF1E293B))),
                  TextSpan(text: 'click to upload', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text('SVG, PNG, or JPG (max 2MB)', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

// Custom CustomPaint Math Layer configuration for rendering dashed frames properly inside containers
class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedRectPainter({required this.color, required this.strokeWidth, required this.gap});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );

    final Path path = Path()..addRRect(rrect);
    final Path metricsPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = gap;
        metricsPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += length + gap;
      }
    }
    canvas.drawPath(metricsPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}