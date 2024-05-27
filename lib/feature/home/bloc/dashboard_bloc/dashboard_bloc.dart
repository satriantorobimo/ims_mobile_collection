import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/home/domain/repo/dashboard_repo.dart';
import 'bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardState get initialState => DashboardInitial();
  DashboardRepo dashboardRepo = DashboardRepo();
  DashboardBloc({required this.dashboardRepo}) : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) async {
      if (event is DashboardAttempt) {
        try {
          emit(DashboardLoading());
          final dashboardResponseModel =
              await dashboardRepo.attemptDashboard(event.collectorCode);
          if (dashboardResponseModel.result == 1) {
            emit(DashboardLoaded(
                dashboardResponseModel: dashboardResponseModel));
          } else if (dashboardResponseModel.result == 0) {
            emit(DashboardError(dashboardResponseModel.message));
          } else {
            emit(const DashboardException('error'));
          }
        } catch (e) {
          emit(DashboardException(e.toString()));
        }
      }
    });
  }
}
