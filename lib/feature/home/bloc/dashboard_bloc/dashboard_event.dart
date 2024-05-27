import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class DashboardAttempt extends DashboardEvent {
  const DashboardAttempt(this.collectorCode);
  final String collectorCode;

  @override
  List<Object> get props => [collectorCode];
}
