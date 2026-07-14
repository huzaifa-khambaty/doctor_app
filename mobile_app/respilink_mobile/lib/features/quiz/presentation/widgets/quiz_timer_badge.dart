import 'dart:async';

import 'package:respilink_mobile/core/utils/duration_utils.dart';

import '../../../../exports.dart';

/// Self-ticking countdown badge, e.g. "14:22" or "1:04:22" for longer limits.
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
      height: 34.r,
      constraints: BoxConstraints(minWidth: 34.r),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
      child: AppText.small(
        label: DurationUtils.formatSeconds(_remaining),
        color: AppColors.error,
        fontWeight: FontWeight.bold,
        fontSize: 11.sp,
      ),
    );
  }
}
