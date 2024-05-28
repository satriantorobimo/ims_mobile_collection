import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_collection/feature/assignment/bloc/task_bloc/bloc.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/feature/assignment/domain/repo/task_repo.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:mobile_collection/utility/drop_down_util.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/network_util.dart';
import 'package:mobile_collection/utility/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  late Position _currentPosition;
  var filterSelect = 0;
  late List<CustDropdownMenuItem> filter = [];
  bool isLoading = true;
  late List<Data> data = [];
  late List<Data> dataFilter = [];
  late List<Data> dataFilterSearch = [];
  TaskListBloc taskListBloc = TaskListBloc(taskRepo: TaskRepo());
  bool isEmpty = false;
  final InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker();

  Future<void> getStatus() async {
    setState(() {
      filter.add(const CustDropdownMenuItem(value: 0, child: Text("ALL")));
      filter
          .add(const CustDropdownMenuItem(value: 1, child: Text("COMPLETED")));
      filter
          .add(const CustDropdownMenuItem(value: 2, child: Text("UNFINISHED")));
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    getStatus();
    getData();

    super.initState();
  }

  getCurrentLocation() async {
    dynamic serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      return Future.error('Location services are disabled.');
    } else {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    }
  }

  Future<void> getData() async {
    final datas = await DatabaseHelper.getUserData();

    NetworkInfo(internetConnectionChecker).isConnected.then((value) {
      if (value) {
        setState(() {
          taskListBloc.add(TaskListAttempt(datas[0]['uid']));
        });
      } else {
        setState(() async {
          final dataTask = await DatabaseHelper.getCust();
          if (dataTask.isEmpty) {
            setState(() {
              isEmpty = true;
            });
          } else {
            setState(() {
              isEmpty = false;
            });
          }
          setState(() {
            dataFilter = dataTask;
            data = dataTask;

            isLoading = false;
          });
        });
      }
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      dataFilterSearch = data
          .where((item) =>
              item.clientName!.toLowerCase().contains(query.toLowerCase()) ||
              item.clientNo!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      dataFilter = dataFilterSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Task List',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BBFB6),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 8.0, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(-6, 4), // Shadow position
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE1E1E1))),
                  child: CustDropDown(
                    maxListHeight: 300,
                    items: filter,
                    hintText: "Select Filter",
                    borderRadius: 5,
                    defaultSelectedIndex: 0,
                    onChanged: (val) {
                      setState(() {
                        filterSelect = val;
                        if (val == 0) {
                          dataFilter = [];
                          dataFilter.addAll(data);
                        } else if (val == 1) {
                          dataFilter = data
                              .where((element) => element.invoiceCount == 0)
                              .toList();
                        } else {
                          dataFilter = data
                              .where((element) => element.invoiceCount! > 0)
                              .toList();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: Material(
              elevation: 6,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(width: 1.0, color: Color(0xFFEAEAEA))),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  decoration: InputDecoration(
                      hintText: 'search record',
                      isDense: true,
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5), fontSize: 15),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ),
          ),
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
                  if (state.taskListResponseModel.data!.isEmpty) {
                    setState(() {
                      isEmpty = true;
                    });
                  } else {
                    setState(() {
                      isEmpty = false;
                    });
                  }
                  setState(() {
                    dataFilter = state.taskListResponseModel.data!;
                    data.addAll(state.taskListResponseModel.data!);
                    isLoading = false;
                  });
                }
                if (state is TaskListError) {
                  if (!mounted) return;
                  GeneralUtil().showSnackBarError(context, state.error!);
                }
                if (state is TaskListException) {
                  if (!mounted) return;
                  GeneralUtil().showSnackBarError(context, state.error);
                }
              },
              child: BlocBuilder(
                  bloc: taskListBloc,
                  builder: (_, TaskListState state) {
                    if (state is TaskListLoading) {
                      return Expanded(
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: 10,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 8);
                                },
                                padding: const EdgeInsets.all(16),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.05)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(
                                              -6, 4), // Shadow position
                                        ),
                                      ],
                                    ),
                                  );
                                })),
                      );
                    }
                    if (state is TaskListLoaded) {
                      return isLoading
                          ? Expanded(
                              child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: 10,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(height: 8);
                                      },
                                      padding: const EdgeInsets.all(16),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          height: 150,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.05)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 6,
                                                offset: const Offset(
                                                    -6, 4), // Shadow position
                                              ),
                                            ],
                                          ),
                                        );
                                      })),
                            )
                          : Expanded(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: dataFilter.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 8);
                                  },
                                  padding: const EdgeInsets.all(16),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            StringRouterUtil
                                                .taskDetailScreenRoute,
                                            arguments: dataFilter[index]);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.05)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                blurRadius: 6,
                                                offset: const Offset(
                                                    -6, 4), // Shadow position
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    width: 109,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: dataFilter[index]
                                                                    .taskStatus! !=
                                                                'COMPLETED'
                                                            ? const Color(
                                                                0xFFFF6969)
                                                            : const Color(
                                                                0xFF70B96E),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topRight:
                                                              Radius.circular(
                                                                  18.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                        )),
                                                    child: Center(
                                                      child: Text(
                                                        dataFilter[index]
                                                            .taskStatus!,
                                                        style: const TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16.0,
                                                    bottom: 16.0,
                                                    top: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${dataFilter[index].invoiceCount} Invoice',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                                  0xFF222222)
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${dataFilter[index].clientName}',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Phone No',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                            0xFF222222)
                                                                        .withOpacity(
                                                                            0.5)),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .phone_outlined,
                                                                    size: 14,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                    '${dataFilter[index].phoneNo1}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.40,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Outstanding Invoices',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                            0xFF222222)
                                                                        .withOpacity(
                                                                            0.5)),
                                                              ),
                                                              Text(
                                                                GeneralUtil.convertToIdr(
                                                                        dataFilter[index]
                                                                            .overdueInstallment!,
                                                                        2)
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 24),
                                                    Text(
                                                      'Location',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                                  0xFF222222)
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .pin_drop_rounded,
                                                          size: 18,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          dataFilter[index]
                                                                          .latitude! ==
                                                                      '' ||
                                                                  dataFilter[index]
                                                                          .longitude! ==
                                                                      ''
                                                              ? '0 km'
                                                              : '${GeneralUtil().calculateDistance(_currentPosition.latitude, _currentPosition.longitude, double.parse(dataFilter[index].latitude!), double.parse(dataFilter[index].longitude!)).toStringAsFixed(2)} km',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${dataFilter[index].fullAddress}',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color(
                                                                  0xFF222222)
                                                              .withOpacity(
                                                                  0.5)),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  }),
                            );
                    }
                    return isLoading
                        ? Expanded(
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 8);
                                    },
                                    padding: const EdgeInsets.all(16),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                              color: Colors.grey
                                                  .withOpacity(0.05)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              blurRadius: 6,
                                              offset: const Offset(
                                                  -6, 4), // Shadow position
                                            ),
                                          ],
                                        ),
                                      );
                                    })),
                          )
                        : Expanded(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: dataFilter.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 8);
                                },
                                padding: const EdgeInsets.all(16),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context,
                                          StringRouterUtil
                                              .taskDetailScreenRoute,
                                          arguments: dataFilter[index]);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          border: Border.all(
                                              color: Colors.grey
                                                  .withOpacity(0.05)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              blurRadius: 6,
                                              offset: const Offset(
                                                  -6, 4), // Shadow position
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                  width: 109,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      color: dataFilter[index]
                                                                  .taskStatus! !=
                                                              'COMPLETED'
                                                          ? const Color(
                                                              0xFFFF6969)
                                                          : const Color(
                                                              0xFF70B96E),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(
                                                                18.0),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                8.0),
                                                      )),
                                                  child: Center(
                                                    child: Text(
                                                      dataFilter[index]
                                                          .taskStatus!,
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16.0,
                                                  bottom: 16.0,
                                                  top: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${dataFilter[index].invoiceCount} Invoice',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                                0xFF222222)
                                                            .withOpacity(0.5)),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${dataFilter[index].clientName}',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.40,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Phone No',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: const Color(
                                                                          0xFF222222)
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .phone_outlined,
                                                                  size: 14,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  '${dataFilter[index].phoneNo1}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.40,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'Outstanding Invoices',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: const Color(
                                                                          0xFF222222)
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            Text(
                                                              GeneralUtil.convertToIdr(
                                                                      dataFilter[
                                                                              index]
                                                                          .overdueInstallment!,
                                                                      2)
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                  Text(
                                                    'Location',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                                0xFF222222)
                                                            .withOpacity(0.5)),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.pin_drop_rounded,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        dataFilter[index]
                                                                        .latitude! ==
                                                                    '' ||
                                                                dataFilter[index]
                                                                        .longitude! ==
                                                                    ''
                                                            ? '0 km'
                                                            : '${GeneralUtil().calculateDistance(-6.2288788, 106.6570876, double.parse(dataFilter[index].latitude!), double.parse(dataFilter[index].longitude!))} km',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${dataFilter[index].fullAddress}',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                                0xFF222222)
                                                            .withOpacity(0.5)),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                }),
                          );
                  })),
        ],
      ),
    );
  }
}
