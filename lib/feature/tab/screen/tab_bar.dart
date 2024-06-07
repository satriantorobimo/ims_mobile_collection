import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/assignment/assignment_screen.dart';
import 'package:mobile_collection/feature/home/home_screen.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';
import 'package:mobile_collection/feature/notification/notification_screen.dart';
import 'package:mobile_collection/feature/profile/profile_screen.dart';
import 'package:mobile_collection/feature/tab/provider/tab_provider.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:provider/provider.dart';

import '../../invoice_detail/bloc/update_bloc/bloc.dart';
import '../../invoice_detail/domain/repo/update_repo.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  List<UpdateRequestModel> updateRequestModel = [];
  UpdateBloc updateBloc = UpdateBloc(updateRepo: UpdateRepo());
  String collCode = '';
  int count = 0;
  Widget _getPage(int index) {
    if (index == 0) {
      return const HomeScreen();
    }
    if (index == 1) {
      return const AssignmentScreen();
    }
    if (index == 2) {
      return const NotificationScreen();
    }
    if (index == 3) {
      return const ProfileScreen();
    }

    return const HomeScreen();
  }

  Future<void> sendData() async {
    Timer.periodic(const Duration(minutes: 5), (timer) {});
  }

  Future<void> getData() async {
    final dataUser = await DatabaseHelper.getUserData();
    collCode = dataUser[0]['uid'];
    final dataTask = await DatabaseHelper.getAgreement();
    if (dataTask.isNotEmpty) {
      for (var datas in dataTask) {
        updateRequestModel.add(UpdateRequestModel(
            pResultCode: datas.resultCode,
            pResultPaymentAmount: datas.resultPaymentAmount!.toInt(),
            pResultPromiseDate: datas.resultPromiseDate,
            pResultRemarks: datas.resultRemarks,
            pTaskId: datas.taskId));
      }
      if (updateRequestModel.isNotEmpty) {
        if (!mounted) return;
        GeneralUtil().showSnackBarSync(context, 'Sync Data');
        updateBloc.add(UpdateAttempt(updateRequestModel[count], collCode));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomBarProvider.page,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: (index) {
          bottomBarProvider.setPage(index);
          bottomBarProvider.setTab(0);
        },
        iconSize: 18,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        selectedLabelStyle: const TextStyle(
            fontSize: 13,
            color: primaryColor,
            height: 1.5,
            fontWeight: FontWeight.w600),
        elevation: 0,
        selectedIconTheme: const IconThemeData(color: primaryColor),
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF575551),
        unselectedLabelStyle: const TextStyle(
            color: Color(0xFF575551), height: 1.5, fontWeight: FontWeight.w600),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/home.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/home.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/application.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/application.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Task List',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/notif.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/notif.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/profile.svg',
              color: const Color(0xFF484C52),
              height: 24,
              width: 24,
            ),
            activeIcon: SvgPicture.asset(
              'assets/icon/profile.svg',
              color: primaryColor,
              height: 24,
              width: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: BlocListener(
          bloc: updateBloc,
          listener: (_, UpdateState state) async {
            if (state is UpdateLoading) {}
            if (state is UpdateLoaded) {
              count++;
              if (count < updateRequestModel.length) {
                updateBloc
                    .add(UpdateAttempt(updateRequestModel[count], collCode));
              } else {
                Navigator.pop(context);
                Future.delayed(const Duration(seconds: 2), () {
                  GeneralUtil()
                      .showSnackBarSuccess(context, 'Success Sync Data');
                });
              }
            }
            if (state is UpdateError) {
              Navigator.pop(context);
              Future.delayed(const Duration(seconds: 2), () {
                GeneralUtil().showSnackBarError(context, state.error!);
              });
            }
            if (state is UpdateException) {
              Navigator.pop(context);
              Future.delayed(const Duration(seconds: 2), () {
                GeneralUtil().showSnackBarError(context, state.error);
              });
            }
          },
          child: _getPage(bottomBarProvider.page)),
    );
  }
}
