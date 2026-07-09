import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class UserPermissionsContent extends StatefulWidget {
  const UserPermissionsContent({super.key});

  @override
  State<UserPermissionsContent> createState() => _UserPermissionsContentState();
}

class _UserPermissionsContentState extends State<UserPermissionsContent> {
  String _selectedRole = 'Clinical Administrator';

  // State Matrix representing permissions mapping for the selected role
  final Map<String, Map<String, bool>> _rolePermissions = {
    'Clinical Administrator': {
      'view_dashboard': true,
      'edit_users': true,
      'enroll_practitioners': true,
      'publish_content': true,
      'create_quizzes': true,
      'manage_events': true,
      'bypass_credentials': false,
      'view_analytics': true,
      'modify_settings': false,
    },
    'Super Admin': {
      'view_dashboard': true,
      'edit_users': true,
      'enroll_practitioners': true,
      'publish_content': true,
      'create_quizzes': true,
      'manage_events': true,
      'bypass_credentials': true,
      'view_analytics': true,
      'modify_settings': true,
    },
    'Medical Officer': {
      'view_dashboard': true,
      'edit_users': false,
      'enroll_practitioners': false,
      'publish_content': true,
      'create_quizzes': false,
      'manage_events': true,
      'bypass_credentials': false,
      'view_analytics': true,
      'modify_settings': false,
    },
  };

  @override
  Widget build(BuildContext context) {
    final permissions = _rolePermissions[_selectedRole] ?? {};

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Breadcrumbs Header Matrix Layout Row
            Row(
              children: [
                Text('Admin', style: TextStyle(fontSize: 12, color: AppColors.textMuted.withValues(alpha: 0.8))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                ),
                const Text('User Management', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
                ),
                const Text('Permissions', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Role Access Control',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 4),
            const Text(
              'Configure system-wide feature permissions and access overrides assigned per professional rank tier.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),
      
            // 2. Global Role Scope Selection Toolbar Card Block
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text(
                    'Select Target Role Profile:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF2F7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedRole,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
                            style: const TextStyle(color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.bold),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _selectedRole = newValue);
                              }
                            },
                            items: _rolePermissions.keys.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
      
            // 3. Structured Module Category Permission Toggles Tree
            _buildCategoryBlock(
              title: 'User & Practitioner Matrix Access',
              icon: Icons.people_alt_outlined,
              children: [
                _buildPermissionToggle(
                  key: 'view_dashboard',
                  label: 'Access Main Admin Dashboard View',
                  description: 'Grabs basic analytical dashboard overview entry rights.',
                  currentMap: permissions,
                ),
                _buildPermissionToggle(
                  key: 'edit_users',
                  label: 'Modify System Profiles & Edit Access Tiers',
                  description: 'Permits account updating, banning, or role shifts.',
                  currentMap: permissions,
                ),
                _buildPermissionToggle(
                  key: 'enroll_practitioners',
                  label: 'Onboard & Execute Manual Practitioner Enrollments',
                  description: 'Allows direct entry addition bypass authorization workflows.',
                  currentMap: permissions,
                ),
              ],
            ),
            const SizedBox(height: 20),
      
            _buildCategoryBlock(
              title: 'Content & Event Repository Matrix',
              icon: Icons.assignment_outlined,
              children: [
                _buildPermissionToggle(
                  key: 'publish_content',
                  label: 'Publish Content, Scientific Papers, and Clinical Modules',
                  description: 'Grants creation/publishing privileges to Content Repository.',
                  currentMap: permissions,
                ),
                _buildPermissionToggle(
                  key: 'create_quizzes',
                  label: 'Draft & Publish Interactive Assessments / Quizzes',
                  description: 'Allows authoring clinician tests or certification checks.',
                  currentMap: permissions,
                ),
                _buildPermissionToggle(
                  key: 'manage_events',
                  label: 'Schedule New Events, Webinars & Summits',
                  description: 'Grants control mapping of upcoming live streams.',
                  currentMap: permissions,
                ),
              ],
            ),
            const SizedBox(height: 20),
      
            _buildCategoryBlock(
              title: 'Administrative Overrides & Base System Configuration',
              icon: Icons.gavel_rounded,
              children: [
                _buildPermissionToggle(
                  key: 'bypass_credentials',
                  label: 'Execute Manual Verification Overrides',
                  description: 'Bypass automated medical certification and license tracking validations.',
                  currentMap: permissions,
                ),
                _buildPermissionToggle(
                  key: 'view_analytics',
                  label: 'Export Analytics Reports & Platform Engagement Stream',
                  description: 'Permits reading and downloading systemic interaction logs.',
                  currentMap: permissions,
                ),
                _buildPermissionToggle(
                  key: 'modify_settings',
                  label: 'Alter Core Platform Settings & Activate Maintenance Mode',
                  description: 'Grants global operational override rights to structural setups.',
                  currentMap: permissions,
                ),
              ],
            ),
            const SizedBox(height: 32),
      
            // 4. Update Actions Confirmation Footer Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Reset Matrix', style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Access Matrix Updated Successfully for $_selectedRole')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005B5C), // Portal thematic color tone alignment
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Save Permissions Layout', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Segment Container Builder Wrapper block pattern
  Widget _buildCategoryBlock({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ],
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          ...children,
        ],
      ),
    );
  }

  // Inline Row Matrix Switch Builder
  Widget _buildPermissionToggle({
    required String key,
    required String label,
    required String description,
    required Map<String, bool> currentMap,
  }) {
    final bool isChecked = currentMap[key] ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Switch.adaptive(
            value: isChecked,
            activeThumbColor: AppColors.primary,
            onChanged: (bool value) {
              setState(() {
                currentMap[key] = value;
              });
            },
          ),
        ],
      ),
    );
  }
}