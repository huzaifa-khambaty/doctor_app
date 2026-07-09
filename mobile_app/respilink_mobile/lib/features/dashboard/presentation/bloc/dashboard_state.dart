class DashboardState {
  final int currentTabIndex;

  const DashboardState({this.currentTabIndex = 0});

  DashboardState copyWith({int? currentTabIndex}) {
    return DashboardState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}
