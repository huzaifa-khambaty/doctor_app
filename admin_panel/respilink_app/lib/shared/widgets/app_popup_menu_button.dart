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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textMuted),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      offset: const Offset(0, 40),
      onSelected: onSelected,
      itemBuilder: (_) {
        final result = <PopupMenuEntry<String>>[];
        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          result.add(PopupMenuItem<String>(
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
            result.add(const PopupMenuDivider(height: 0.5));
          }
        }
        return result;
      },
    );
  }
}
