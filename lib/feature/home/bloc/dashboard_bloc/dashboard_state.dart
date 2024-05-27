import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/home/data/dashboard_response_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({required this.dashboardResponseModel});
  final DashboardResponseModel dashboardResponseModel;

  @override
  List<Object> get props => [dashboardResponseModel];
}

class DashboardError extends DashboardState {
  const DashboardError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DashboardException extends DashboardState {
  const DashboardException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
