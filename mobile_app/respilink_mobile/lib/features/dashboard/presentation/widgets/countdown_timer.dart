import 'dart:async';

import '../../../../exports.dart';

/// Live-ticking countdown, e.g. for a daily challenge's remaining time.
class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Color? color;

  const CountdownTimer({super.key, required this.duration, this.color});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining = widget.duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) {
        _timer?.cancel();
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formatted {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined, color: color, size: 14.sp),
        SizedBox(width: 4.w),
        AppText.small(
          label: _formatted,
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ],
    );
  }
}
