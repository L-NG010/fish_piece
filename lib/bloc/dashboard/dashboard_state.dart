abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<dynamic> dashboardData;

  DashboardLoaded({required this.dashboardData});
}
class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
