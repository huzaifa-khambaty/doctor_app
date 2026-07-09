import 'dart:async';

import '../../../../exports.dart';

/// Self-ticking per-question countdown shown as a red circular badge, e.g. "11s".
class QuizTimerBadge extends StatefulWidget {
  final int seconds;
  final VoidCallback? onExpire;

  const QuizTimerBadge({super.key, required this.seconds, this.onExpire});

  @override
  State<QuizTimerBadge> createState() => _QuizTimerBadgeState();
}

class _QuizTimerBadgeState extends State<QuizTimerBadge> {
  late int _remaining = widget.seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        setState(() => _remaining = 0);
        widget.onExpire?.call();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.r,
      height: 34.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
      child: AppText.small(
        label: '${_remaining}s',
        color: AppColors.error,
        fontWeight: FontWeight.bold,
        fontSize: 11.sp,
      ),
    );
  }
}
