import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/amortization/amortization_screen.dart';
import 'package:mobile_collection/feature/assignment/domain/repo/task_repo.dart';
import 'package:mobile_collection/feature/home/bloc/dashboard_bloc/bloc.dart';
import 'package:mobile_collection/feature/home/domain/repo/dashboard_repo.dart';
import 'package:mobile_collection/feature/home/provider/home_provider.dart';
import 'package:mobile_collection/feature/tab/provider/tab_provider.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:mobile_collection/utility/drop_down_util.dart';
import 'package:mobile_collection/utility/firebase_notification_service.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/network_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/string_router_util.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../assignment/bloc/task_bloc/bloc.dart';
import 'widget/header_tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int taskLength = 0;
  int taskDone = 0;
  int taskSync = 0;

  int alreadyPaid = 0;
  int paid = 0;
  int promise = 0;
  int notPaid = 0;
  int notFound = 0;
  int notResult = 0;

  String dailyCountCust = '0';
  String dailyTargetCust = '0';
  String monthCountCust = '0';
  String monthTargetCust = '0';

  String dailyCountInv = '0';
  String dailyTargetInv = '0';
  String monthCountInv = '0';
  String monthTargetInv = '0';

  String dailyCountCa = '0';
  String dailyTargetCa = '0';
  String monthCountCa = '0';
  String monthTargetCa = '0';
  bool isConnect = false;
  bool isLoading = true;
  bool isLoadingAchieve = true;
  late List<CustDropdownMenuItem> filter = [];
  TaskListBloc taskListBloc = TaskListBloc(taskRepo: TaskRepo());
  DashboardBloc dashboardBloc = DashboardBloc(dashboardRepo: DashboardRepo());
  final InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker();

  Future<void> getStatus() async {
    setState(() {
      filter.add(const CustDropdownMenuItem(
          value: 0, data: 'Daily', child: Text("Daily")));
      filter.add(const CustDropdownMenuItem(
          value: 1, data: 'This Month', child: Text("This Month")));
    });
  }

  @override
  void initState() {
    getStatus();
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final data = await DatabaseHelper.getUserData();

    NetworkInfo(internetConnectionChecker).isConnected.then((value) {
      if (value) {
        setState(() {
          taskListBloc.add(TaskListAttempt(data[0]['uid']));
        });
      } else {
        setState(() async {
          final dataSync = await DatabaseHelper.getAgreementSync();
          final dataDone = await DatabaseHelper.getAgreementDone();
          final dataTask = await DatabaseHelper.getAgreement();
          setState(() {
            taskLength = dataTask.length;

            taskSync = dataSync.length;
            taskDone = dataDone.length;
            isLoading = false;
          });
        });
      }
    });
  }

  Future<void> showBottomExpired() {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStates) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding:
                        const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                    child: Center(
                      child: Image.asset(
                        'assets/img/back.png',
                        width: 150,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 24.0, left: 24, right: 24, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'Sesi Anda Telah Habis',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Silahkan Login Ulang',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: InkWell(
                    onTap: () async {
                      final FirebaseNotificationService
                          firebaseNotificationService =
                          FirebaseNotificationService();
                      final data = await DatabaseHelper.getUserData();

                      await firebaseNotificationService
                          .fcmUnSubscribe(data[0]['uid']);

                      SharedPrefUtil.deleteSharedPref('token');
                      await DatabaseHelper.deleteUser();
                      if (!mounted) return;
                      var bottomBarProvider =
                          Provider.of<TabProvider>(context, listen: false);
                      bottomBarProvider.setPage(0);
                      bottomBarProvider.setTab(0);
                      Navigator.pushNamedAndRemoveUntil(context,
                          StringRouterUtil.loginScreenRoute, (route) => false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 45,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('OK',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          });
        });
  }

  Future<void> showBottomFilter() {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    int selectFilter = homeProvider.filterSelect;
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return Wrap(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 24.0, left: 16, right: 16),
                child: Text(
                  'Achievement',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 24, right: 24, bottom: 24),
                child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filter.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: Divider(),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          homeProvider.setFilter(index);
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              filter[index].data,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            selectFilter == index
                                ? const Icon(Icons.check_rounded,
                                    color: primaryColor)
                                : Container()
                          ],
                        ),
                      );
                    }),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF9BBFB6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28.0),
                  bottomRight: Radius.circular(28.0),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      top: 50.0, bottom: 40, left: 16, right: 16),
                  child: HeaderTabWidget(),
                ),
                mainContent(context)

                // ))
              ],
            ),
          ],
        ));
  }

  Widget mainContent(BuildContext context) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        BlocListener(
            bloc: taskListBloc,
            listener: (_, TaskListState state) async {
              if (state is TaskListLoading) {}
              if (state is TaskListLoaded) {
                final data = await DatabaseHelper.getDateLogin();
                DateTime? selectedDate = DateTime.now();
                DateTime dateNows = selectedDate.getDateOnly();
                log(dateNows.toString());
                DateTime tempDate =
                    DateFormat('yyyy-MM-dd').parse(data[0]['date']);
                log(tempDate.toString());
                if (selectedDate.isAfter(tempDate)) {
                  await DatabaseHelper.deleteData();
                  await DatabaseHelper.updateDateLogin(
                      date: dateNows.toString(), uid: data[0]['uid']);
                }
                await DatabaseHelper.insertCust(
                    state.taskListResponseModel.data!);
                for (var val in state.taskListResponseModel.data!) {
                  if (val.agreementList!.isNotEmpty) {
                    await DatabaseHelper.insertAgreement(val.agreementList!);
                    if (val.agreementList!.first.attachmentList!.isNotEmpty) {
                      for (var vals in val.agreementList!) {
                        if (vals.attachmentList != null) {
                          await DatabaseHelper.insertAttachmentList(
                              vals.attachmentList!, vals.taskId!);
                        }
                      }
                    }
                  }
                }
                final dataSync = await DatabaseHelper.getAgreementSync();
                final dataDone = await DatabaseHelper.getAgreementDone();
                final dataTask = await DatabaseHelper.getAgreement();
                setState(() {
                  taskLength = dataTask.length;

                  taskSync = dataSync.length;
                  taskDone = dataDone.length;
                  isLoading = false;
                });
                dashboardBloc.add(DashboardAttempt(data[0]['uid']));
              }
              if (state is TaskListError) {
                if (!mounted) return;
                if (state.error! == 'expired') {
                  showBottomExpired();
                } else {
                  GeneralUtil().showSnackBarError(context, state.error!);
                }
              }
              if (state is TaskListException) {
                if (!mounted) return;
                if (state.error == 'expired') {
                  showBottomExpired();
                } else {
                  GeneralUtil()
                      .showSnackBarError(context, 'Internal Server Error');
                }
              }
            },
            child: BlocBuilder(
                bloc: taskListBloc,
                builder: (_, TaskListState state) {
                  if (state is TaskListLoading) {
                    return dailyTaskLoading();
                  }
                  if (state is TaskListLoaded) {
                    return isLoading ? dailyTaskLoading() : dailyTask();
                  }
                  return isLoading ? dailyTaskLoading() : dailyTask();
                })),
        const SizedBox(
          height: 24,
        ),
        BlocListener(
            bloc: dashboardBloc,
            listener: (_, DashboardState state) async {
              if (state is DashboardLoading) {}
              if (state is DashboardLoaded) {
                await DatabaseHelper.insertAchievement(
                    state.dashboardResponseModel.data![1].achievement!);

                await DatabaseHelper.insertDasilyStatus(
                    state.dashboardResponseModel.data![0].dailyTaskStatus!);

                final dataDaily = await DatabaseHelper.getDailyStatus();
                final dataAchieve = await DatabaseHelper.getAchievement();

                for (int i = 0; i < dataDaily.length; i++) {
                  if (dataDaily[i].resultStatus == 'already_paid') {
                    setState(() {
                      alreadyPaid = dataDaily[i].resultCount!;
                    });
                  }
                  if (dataDaily[i].resultStatus == 'paid') {
                    setState(() {
                      paid = dataDaily[i].resultCount!;
                    });
                  }
                  if (dataDaily[i].resultStatus == 'promise') {
                    setState(() {
                      promise = dataDaily[i].resultCount!;
                    });
                  }
                  if (dataDaily[i].resultStatus == 'not_paid') {
                    setState(() {
                      notPaid = dataDaily[i].resultCount!;
                    });
                  }
                  if (dataDaily[i].resultStatus == 'not_found') {
                    setState(() {
                      notFound = dataDaily[i].resultCount!;
                    });
                  }
                  if (dataDaily[i].resultStatus == 'no_result') {
                    setState(() {
                      notResult = dataDaily[i].resultCount!;
                    });
                  }
                }

                for (int i = 0; i < dataAchieve.length; i++) {
                  if (dataAchieve[i].category == 'customer') {
                    setState(() {
                      dailyCountCust = dataAchieve[i].dailyCount!;
                      monthCountCust = dataAchieve[i].monthlyCount!;
                      dailyTargetCust = dataAchieve[i].dailyTarget!;
                      monthTargetCust = dataAchieve[i].monthlyTarget!;
                    });
                  }

                  if (dataAchieve[i].category == 'invoice') {
                    setState(() {
                      dailyCountInv = dataAchieve[i].dailyCount!;
                      monthCountInv = dataAchieve[i].monthlyCount!;
                      dailyTargetInv = dataAchieve[i].dailyTarget!;
                      monthTargetInv = dataAchieve[i].monthlyTarget!;
                    });
                  }

                  if (dataAchieve[i].category == 'collected_amount') {
                    setState(() {
                      dailyCountCa = dataAchieve[i].dailyCount!;
                      monthCountCa = dataAchieve[i].monthlyCount!;
                      dailyTargetCa = dataAchieve[i].dailyTarget!;
                      monthTargetCa = dataAchieve[i].monthlyTarget!;
                    });
                  }
                }

                setState(() {
                  isLoadingAchieve = false;
                });
              }
              if (state is DashboardError) {
                if (!mounted) return;
                GeneralUtil().showSnackBarError(context, state.error!);
              }
              if (state is DashboardException) {
                if (!mounted) return;
                GeneralUtil().showSnackBarError(context, state.error);
              }
            },
            child: BlocBuilder(
                bloc: dashboardBloc,
                builder: (_, DashboardState state) {
                  if (state is DashboardLoading) {
                    return dailyAchieveLoading();
                  }
                  if (state is DashboardLoaded) {
                    return isLoadingAchieve
                        ? dailyAchieveLoading()
                        : achievement();
                  }
                  return dailyAchieveLoading();
                })),
      ],
    ));
  }

  Widget achievement() {
    var homeProvider = Provider.of<HomeProvider>(context);
    int selectFilter = homeProvider.filterSelect;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(
                color: Color(0xFF759089),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$alreadyPaid',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Already\nPaid',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(
                color: Color(0xFF759089),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$paid',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Paid',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(
                color: Color(0xFF759089),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$promise',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Promise',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          ]),
          const SizedBox(
            height: 16,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(
                color: Color(0xFF759089),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$notPaid',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Not\nPaid',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(
                color: Color(0xFF759089),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$notFound',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Not\nFound',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width * 0.28,
              height: MediaQuery.of(context).size.height * 0.065,
              decoration: const BoxDecoration(
                color: Color(0xFF3C3D3D),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$notResult',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'No\nResult',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          ]),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icon/today.svg',
                    color: Colors.black,
                    height: 18,
                    width: 22.5,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Achievement',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: showBottomFilter,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        filter[selectFilter].data,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      color: Color(0xFF9BBFB6),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: SvgPicture.asset(
                              'assets/icon/profile.svg',
                              color: const Color(0xFF414F4B),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Customer',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707070)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectFilter == 1 ? monthCountCust : dailyCountCust,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF414F4B)),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.height * 0.08,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color(0xFF759089),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Target',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectFilter == 1
                                          ? monthTargetCust
                                          : dailyTargetCust,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      )
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      color: Color(0xFF9BBFB6),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: SvgPicture.asset(
                              'assets/icon/inv.svg',
                              color: const Color(0xFF414F4B),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Invoices',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707070)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectFilter == 1 ? monthCountInv : dailyCountInv,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF414F4B)),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.height * 0.08,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color(0xFF759089),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Target',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectFilter == 1
                                          ? monthTargetInv
                                          : dailyTargetInv,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      )
                    ],
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(
                      color: Color(0xFF9BBFB6),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          Center(
                            child: SvgPicture.asset(
                              'assets/icon/amount.svg',
                              color: const Color(0xFF414F4B),
                              height: 24,
                              width: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Collected Amount',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF707070)),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectFilter == 1 ? monthCountCa : dailyCountCa,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF414F4B)),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.height * 0.08,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Color(0xFF759089),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Target',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      selectFilter == 1
                                          ? monthTargetCa
                                          : dailyTargetCa,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget dailyTask() {
    var completed = taskDone / taskLength;
    var sync = taskSync / taskDone;
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icon/task-status.svg',
                color: Colors.black,
                height: 18,
                width: 22.5,
              ),
              const SizedBox(width: 8),
              const Text(
                'Daily Task Status',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(-6, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: CircularPercentIndicator(
                    radius: 70.0,
                    lineWidth: 18.0,
                    percent: completed,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$taskDone / $taskLength',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Completed',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    progressColor: const Color(0xFF759089),
                    reverse: true,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(-6, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: CircularPercentIndicator(
                    radius: 70.0,
                    lineWidth: 18.0,
                    percent: sync,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$taskSync / $taskDone',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Sync',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    progressColor: const Color(0xFF759089),
                    reverse: true,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget dailyTaskLoading() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade300,
              ),
              width: 100,
              height: 18,
            ),
          ),
          const SizedBox(
            height: 17,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 180,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 180,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dailyAchieveLoading() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
          ]),
          const SizedBox(
            height: 16,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade300,
                ),
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.065,
              ),
            ),
          ]),
          const SizedBox(
            height: 40,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade300,
              ),
              width: 100,
              height: 18,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade300,
                  ),
                  width: MediaQuery.of(context).size.width * 0.28,
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
