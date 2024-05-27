import 'package:mobile_collection/feature/home/data/dashboard_response_model.dart';
import 'package:mobile_collection/feature/home/domain/api/dashboard_api.dart';

class DashboardRepo {
  final DashboardApi dashboardApi = DashboardApi();
  Future<DashboardResponseModel> attemptDashboard(String collectorCode) =>
      dashboardApi.attemptDashboard(collectorCode);
}
