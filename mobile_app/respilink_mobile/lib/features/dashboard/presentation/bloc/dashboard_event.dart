abstract class DashboardEvent {}

class ChangeTabRequested extends DashboardEvent {
  final int index;

  ChangeTabRequested(this.index);
}
