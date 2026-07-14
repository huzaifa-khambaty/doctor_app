class DurationUtils {
  DurationUtils._();

  /// Formats a duration as a clock string — `H:MM:SS` once it spans at least
  /// an hour, otherwise `M:SS`. Centralized so every countdown/timer in the
  /// app (quiz timers, etc.) renders minutes/hours consistently instead of
  /// raw seconds.
  static String formatClock(Duration duration) {
    final isNegative = duration.isNegative;
    final abs = isNegative ? -duration : duration;

    final hours = abs.inHours;
    final minutes = abs.inMinutes % 60;
    final seconds = abs.inSeconds % 60;
    final sign = isNegative ? '-' : '';

    if (hours > 0) {
      return '$sign$hours:${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '$sign$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Formats a whole-seconds count using [formatClock].
  static String formatSeconds(int seconds) =>
      formatClock(Duration(seconds: seconds));
}
