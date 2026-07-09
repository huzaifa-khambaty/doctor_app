import 'package:respilink_mobile/exports.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final Widget? emptyWidget;
  final bool isEmpty;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.emptyWidget,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = isEmpty
        ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 180.h),
              emptyWidget ?? const SizedBox.shrink(),
            ],
          )
        : child;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: content,
    );
  }
}
