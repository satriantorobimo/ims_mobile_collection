import 'package:flutter/material.dart';
import 'package:mobile_collection/feature/amortization/amortization_screen.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';

import 'package:mobile_collection/feature/invoice_detail/invoice_detail_screen.dart';
import 'package:mobile_collection/feature/invoice_history/invoice_history_screen.dart';
import 'package:mobile_collection/feature/login/login_screen.dart';
import 'package:mobile_collection/feature/splash/splash_screen.dart';
import 'package:mobile_collection/feature/tab/screen/tab_bar.dart';
import 'package:mobile_collection/feature/task_detail/task_detail_screen.dart';
import 'package:mobile_collection/utility/string_router_util.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StringRouterUtil.splashScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const SplashScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));
      case StringRouterUtil.loginScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.tabScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const TabBarScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.taskDetailScreenRoute:
        final Data data = settings.arguments as Data;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => TaskDetailScreen(data: data),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.invoiceDetailScreenRoute:
        final AgreementList agreementList = settings.arguments as AgreementList;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => InvoiceDetailScreen(
                  agreementList: agreementList,
                ),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.invoiceHistoryScreenRoute:
        final AgreementList agreementList = settings.arguments as AgreementList;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                InvoiceHistoryScreen(agreementList: agreementList),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.amortizationScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const AmortizationScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
