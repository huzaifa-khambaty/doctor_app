abstract class AnalyticsEvent {}

class FetchAnalyticsRequested extends AnalyticsEvent {
  final String period;
  FetchAnalyticsRequested({this.period = 'weekly'});
}
