import 'package:flutter/material.dart';
import 'package:respilink_app/core/theme/app_colors.dart';

class AppPopupMenuItem {
  final String value;
  final IconData icon;
  final String label;
  final Color color;
  final bool hasDividerAfter;

  const AppPopupMenuItem({
    required this.value,
    required this.icon,
    required this.label,
    required this.color,
    this.hasDividerAfter = false,
  });
}

class AppPopupMenuButton extends StatelessWidget {
  final List<AppPopupMenuItem> items;
  final void Function(String) onSelected;

  const AppPopupMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
  });

  Future<void> _show(BuildContext context) async {
    final button = context.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (button == null || overlay == null) return;

    final position = RelativeRect.fromRect(
      button.localToGlobal(Offset.zero, ancestor: overlay) & button.size,
      Offset.zero & overlay.size,
    );

    final entries = <PopupMenuEntry<String>>[];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      entries.add(PopupMenuItem<String>(
        value: item.value,
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(item.icon, color: item.color, size: 20),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: item.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
      if (item.hasDividerAfter && i < items.length - 1) {
        entries.add(const PopupMenuDivider(height: 0.5));
      }
    }

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: entries,
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
    );

    if (selected != null) onSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textMuted),
      onPressed: () => _show(context),
    );
  }
}
