class StringRouterUtil {
  factory StringRouterUtil() => _instance;
  StringRouterUtil.internal();
  static final StringRouterUtil _instance = StringRouterUtil.internal();

  static const String splashScreenRoute = '/';
  static const String loginScreenRoute = '/login-route';
  static const String tabScreenRoute = '/tab-route';
  static const String taskDetailScreenRoute = '/task-detail-route';
  static const String invoiceDetailScreenRoute = '/invoice-detail-route';
  static const String invoiceHistoryScreenRoute = '/invoice-history-route';
  static const String amortizationScreenRoute = '/amortization-route';
  static const String imageAssetScreenRoute = '/image-asset-route';
  static const String imageNetworkScreenRoute = '/image-network-route';
}
