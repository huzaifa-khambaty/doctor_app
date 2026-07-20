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
    return ValueListenableBuilder(
      valueListenable: GlobalNotifiers.adminNotifier,
      builder: (context, admin, _) {
        // PERMISSION GATING DISABLED — re-enable by removing the `return true` lines
        bool hasPerm(String p) => true;
        bool hasAnyPerm(List<String> perms) => true;
        // bool hasPerm(String p) {
        //   if (admin == null) return false;
        //   if (admin.roles?.contains('super_admin') == true) return true;
        //   return admin.permissions?.contains(p) == true;
        // }
        // bool hasAnyPerm(List<String> perms) => perms.any(hasPerm);

        return Container(
          color: AppColors.sidebarBg,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: isCollapsed
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
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
                Icon(Icons.medical_information, color: Colors.white, size: 28),
              ],

              const SizedBox(height: 32),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (hasPerm('users.view'))
                      _SidebarItem(
                        icon: Icons.grid_view_rounded,
                        title: 'Dashboard',
                        isActive: selectedIndex == 0,
                        isCollapsed: isCollapsed,
                        onTap: (v) => onDestinationSelected?.call(v),
                        index: 0,
                      ),
                    if (hasPerm('users.view'))
                      _SidebarItem(
                        icon: Icons.people_outline_rounded,
                        title: 'Users',
                        isCollapsed: isCollapsed,
                        isActive: selectedIndex == 1,
                        onTap: (v) => onDestinationSelected?.call(v),
                        index: 1,
                      ),
                    _SidebarItem(
                      icon: Icons.description_outlined,
                      title: 'Content',
                      isCollapsed: isCollapsed,
                      isActive: selectedIndex == 2,
                      onTap: (v) => onDestinationSelected?.call(v),
                      index: 2,
                    ),
                    if (hasPerm('quizzes.view'))
                      _SidebarItem(
                        icon: Icons.quiz_outlined,
                        title: 'Quizzes',
                        isCollapsed: isCollapsed,
                        isActive: selectedIndex == 3,
                        onTap: (v) => onDestinationSelected?.call(v),
                        index: 3,
                      ),
                    if (hasPerm('events.view'))
                      _SidebarItem(
                        icon: Icons.calendar_today_outlined,
                        title: 'Events',
                        isCollapsed: isCollapsed,
                        isActive: selectedIndex == 4,
                        onTap: (v) => onDestinationSelected?.call(v),
                        index: 4,
                      ),
                    _SidebarItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Queries',
                      isCollapsed: isCollapsed,
                      isActive: selectedIndex == 5,
                      onTap: (v) => onDestinationSelected?.call(v),
                      index: 5,
                    ),
                    if (hasAnyPerm(['admins.view', 'users.view']))
                      _SidebarItem(
                        icon: Icons.analytics_outlined,
                        title: 'Analytics',
                        isCollapsed: isCollapsed,
                        isActive: selectedIndex == 6,
                        onTap: (v) => onDestinationSelected?.call(v),
                        index: 6,
                      ),
                    if (hasAnyPerm(['admins.view', 'roles.manage']))
                      _ExpandableSidebarGroup(
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Admin Management',
                        isCollapsed: isCollapsed,
                        isGroupActive: selectedIndex == 7 || selectedIndex == 8,
                        children: [
                          _SidebarSubItem(
                            title: 'User Management',
                            isActive: selectedIndex == 7,
                            onTap: () => onDestinationSelected?.call(7),
                          ),
                          _SidebarSubItem(
                            title: 'Permissions',
                            isActive: selectedIndex == 8,
                            onTap: () => onDestinationSelected?.call(8),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const Divider(color: Colors.white12, height: 32),
              if (hasAnyPerm(['admins.view', 'roles.manage'])) ...[
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  isCollapsed: isCollapsed,
                  isActive: selectedIndex == 9,
                  onTap: (v) => onDestinationSelected?.call(v),
                  index: 9,
                ),
                const SizedBox(height: 16),
              ],

              InkWell(
                onTap: () => onDestinationSelected?.call(10),
                child: _UserProfileFooter(isCollapsed: isCollapsed),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ExpandableSidebarGroup extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isCollapsed;
  final bool isGroupActive;
  final List<Widget> children;

  const _ExpandableSidebarGroup({
    required this.icon,
    required this.title,
    required this.isCollapsed,
    required this.isGroupActive,
    required this.children,
  });

  @override
  State<_ExpandableSidebarGroup> createState() =>
      _ExpandableSidebarGroupState();
}

class _ExpandableSidebarGroupState extends State<_ExpandableSidebarGroup> {
  late bool _isExpanded;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isGroupActive;
  }

  @override
  void didUpdateWidget(_ExpandableSidebarGroup old) {
    super.didUpdateWidget(old);
    if (!old.isGroupActive && widget.isGroupActive) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Icon(widget.icon, color: widget.isGroupActive ? Colors.white : Colors.white60, size: 22),
      );
    }

    final bool useHighlight = widget.isGroupActive || _isHovered;
    final Color itemBgColor =
        useHighlight ? Colors.white.withValues(alpha: 0.12) : Colors.transparent;
    final Color contentColor =
        widget.isGroupActive ? Colors.white : (_isHovered ? Colors.white : Colors.white60);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            onHover: (h) => setState(() => _isHovered = h),
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white10,
            highlightColor: Colors.transparent,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: itemBgColor,
                borderRadius: BorderRadius.circular(8),
                border: widget.isGroupActive
                    ? Border.all(color: Colors.white24, width: 1)
                    : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(widget.icon, color: contentColor, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: contentColor,
                        fontSize: 14,
                        fontWeight: widget.isGroupActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: contentColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(children: widget.children),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SidebarSubItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarSubItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarSubItem> createState() => _SidebarSubItemState();
}

class _SidebarSubItemState extends State<_SidebarSubItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color contentColor =
        widget.isActive ? Colors.white : (_isHovered ? Colors.white : Colors.white54);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (h) => setState(() => _isHovered = h),
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white10,
        highlightColor: Colors.transparent,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: widget.isActive || _isHovered
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: widget.isActive ? Colors.white : Colors.white38,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 13,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────

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
