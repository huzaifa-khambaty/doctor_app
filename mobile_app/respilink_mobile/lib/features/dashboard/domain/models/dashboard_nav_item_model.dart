class DashboardNavItemModel {
  final String label;
  final String svgIcon;

  const DashboardNavItemModel({required this.label, required this.svgIcon});
}

const List<DashboardNavItemModel> dashboardNavItems = [
  DashboardNavItemModel(label: 'Home', svgIcon: 'home.svg'),
  DashboardNavItemModel(label: 'Events', svgIcon: 'events.svg'),
  DashboardNavItemModel(label: 'Quiz', svgIcon: 'quiz.svg'),
  DashboardNavItemModel(label: 'Library', svgIcon: 'library.svg'),
  DashboardNavItemModel(label: 'Profile', svgIcon: 'profile.svg'),
];
