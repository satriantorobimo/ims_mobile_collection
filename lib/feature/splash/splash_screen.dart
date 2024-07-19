import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/feature/amortization/amortization_screen.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/string_router_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _goToLogin();

    super.initState();
  }

  void _goToLogin() {
    Future.delayed(const Duration(seconds: 2), () async {
      SharedPrefUtil.getSharedString('token').then((value) async {
        if (value == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, StringRouterUtil.loginScreenRoute, (route) => false);
        } else {
          final data = await DatabaseHelper.getDateLogin();
          DateTime? selectedDate = DateTime.now().getDateOnly();
          log(selectedDate.toString());
          DateTime tempDate = DateFormat('yyyy-MM-dd').parse(data[0]['date']);
          if (selectedDate.isAfter(tempDate)) {
            await DatabaseHelper.deleteData();
            await DatabaseHelper.updateDateLogin(
                date: selectedDate.toString(), uid: data[0]['uid']);
          }
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
              context, StringRouterUtil.tabScreenRoute, (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Center(
              child: Image.asset(
            'assets/logo.png',
            width: MediaQuery.of(context).size.width * 0.65,
          )),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Version',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
