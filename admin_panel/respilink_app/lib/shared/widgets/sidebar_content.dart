import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';
import 'package:respilink_app/core/utils/global_notifiers.dart';
import 'package:respilink_app/shared/widgets/app_network_image.dart';

class MySidebarContent extends StatelessWidget {
  final bool isCollapsed;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const MySidebarContent({
    super.key,
    this.isCollapsed = false,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sidebarBg,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: isCollapsed
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // App Title branding from image_bd8279.png
          if (!isCollapsed) ...[
            const Text(
              'RespiLink Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Clinical Management',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ] else ...[
            // Small logo alternative when sidebar collapses for tablet view
            Icon(Icons.medical_information, color: Colors.white, size: 28),
          ],

          const SizedBox(height: 32),

          // Main Navigation Links Section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarItem(
                  icon: Icons.grid_view_rounded,
                  title: 'Dashboard',
                  isActive: selectedIndex == 0,
                  isCollapsed: isCollapsed,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 0,
                ),
                _SidebarItem(
                  icon: Icons.people_outline_rounded,
                  title: 'Users',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 1,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 1,
                ),
                _SidebarItem(
                  icon: Icons.description_outlined,
                  title: 'Content',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 2,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 2,
                ),
                _SidebarItem(
                  icon: Icons.quiz_outlined,
                  title: 'Quizzes',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 3,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 3,
                ),
                _SidebarItem(
                  icon: Icons.calendar_today_outlined,
                  title: 'Events',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 4,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 4,
                ),
                _SidebarItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Queries',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 5,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 5,
                ),
                _SidebarItem(
                  icon: Icons.analytics_outlined,
                  title: 'Analytics',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 6,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 6,
                ),
                _SidebarItem(
                  icon: Icons.security_outlined,
                  title: 'Permissions',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 7,
                  onTap: (value) => onDestinationSelected?.call(value),
                  index: 7,
                ),
              ],
            ),
          ),

          // Bottom Settings & Profile Block
          const Divider(color: Colors.white12, height: 32),
          _SidebarItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            isCollapsed: isCollapsed,
            isActive: selectedIndex == 8,
            onTap: (value) => onDestinationSelected?.call(value),
            index: 8,
          ),
          const SizedBox(height: 16),

          // User Profile Area
          InkWell(
            onTap: () => onDestinationSelected?.call(9),
            child: _UserProfileFooter(isCollapsed: isCollapsed),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isCollapsed;
  final Function(int) onTap;
  final int index;

  const _SidebarItem({
    required this.icon,
    required this.title,
    this.isActive = false,
    required this.isCollapsed,
    required this.onTap,
    required this.index,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Determine dynamic background and text colors based on active or hover states
    final bool useHighlight = widget.isActive || _isHovered;
    final Color itemBgColor = useHighlight
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.transparent;
    final Color contentColor = widget.isActive
        ? Colors.white
        : (_isHovered ? Colors.white : Colors.white60);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => widget.onTap(widget.index),
        onHover: (hovering) {
          setState(() {
            _isHovered = hovering;
          });
        },
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white10,
        highlightColor: Colors.transparent,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: itemBgColor,
            borderRadius: BorderRadius.circular(8),
            border: widget.isActive
                ? Border.all(color: Colors.white24, width: 1)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Flexible(child: Icon(widget.icon, color: contentColor, size: 22)),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 14),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 14,
                    fontWeight: widget.isActive
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileFooter extends StatelessWidget {
  final bool isCollapsed;

  const _UserProfileFooter({required this.isCollapsed});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: GlobalNotifiers.adminNotifier,
          builder: (context, user, child) {
            return Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                AppNetworkImage(
                  imageUrl: "",
                  width: 36,
                  height: 36,
                  isCircle: true,
                  errorWidget: CircleAvatar(
                    backgroundColor: AppColors.white,
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.name ?? 'Admin User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          user?.name ?? 'Admin User',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
