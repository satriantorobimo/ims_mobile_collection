import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_collection/feature/assignment/domain/repo/task_repo.dart';
import 'package:mobile_collection/feature/home/bloc/dashboard_bloc/bloc.dart';
import 'package:mobile_collection/feature/home/data/dashboard_response_model.dart';
import 'package:mobile_collection/feature/home/domain/repo/dashboard_repo.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:mobile_collection/utility/drop_down_util.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../assignment/bloc/task_bloc/bloc.dart';
import 'widget/header_tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var filterSelect = 0;
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

  bool isLoading = true;
  bool isLoadingAchieve = true;
  late List<CustDropdownMenuItem> filter = [];
  TaskListBloc taskListBloc = TaskListBloc(taskRepo: TaskRepo());
  DashboardBloc dashboardBloc = DashboardBloc(dashboardRepo: DashboardRepo());

  Future<void> getStatus() async {
    setState(() {
      filter
          .add(const CustDropdownMenuItem(value: 0, child: Text("This Month")));
      filter.add(const CustDropdownMenuItem(value: 1, child: Text("Daily")));
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
    taskListBloc.add(TaskListAttempt(data[0]['uid']));
    dashboardBloc.add(DashboardAttempt(data[0]['uid']));
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
                await DatabaseHelper.insertCust(
                    state.taskListResponseModel.data!);
                for (var val in state.taskListResponseModel.data!) {
                  await DatabaseHelper.insertAgreement(val.agreementList!);
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
              }
              if (state is TaskListError) {}
              if (state is TaskListException) {}
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
                  return dailyTaskLoading();
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
              if (state is DashboardError) {}
              if (state is DashboardException) {}
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
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: 45,
                padding: const EdgeInsets.all(8.0),
                child: CustDropDown(
                  maxListHeight: 300,
                  items: filter,
                  hintText: "Select Filter",
                  borderRadius: 5,
                  defaultSelectedIndex: 0,
                  onChanged: (val) {
                    setState(() {
                      filterSelect = val;
                    });
                  },
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
                            filterSelect == 0 ? monthCountCust : dailyCountCust,
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
                                      filterSelect == 0
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
                            filterSelect == 0 ? monthCountInv : dailyCountInv,
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
                                      filterSelect == 0
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
                            filterSelect == 0 ? monthCountCa : dailyCountCa,
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
                                      filterSelect == 0
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
                    percent: 0.8,
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
                    percent: 0.9,
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
