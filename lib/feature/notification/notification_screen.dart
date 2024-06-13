import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/feature/notification/bloc/notification_bloc/bloc.dart';
import 'package:mobile_collection/feature/notification/data/notification_response_model.dart';
import 'package:mobile_collection/feature/notification/domain/repo/notification_repo.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationBloc notificationBloc =
      NotificationBloc(notificationRepo: NotificationRepo());

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final datas = await DatabaseHelper.getUserData();
    notificationBloc.add(NotificationAttempt(datas[0]['uid']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BBFB6),
      ),
      body: BlocListener(
          bloc: notificationBloc,
          listener: (_, NotificationState state) async {
            if (state is NotificationLoading) {}
            if (state is NotificationLoaded) {}
            if (state is NotificationError) {}
            if (state is NotificationException) {}
          },
          child: BlocBuilder(
              bloc: notificationBloc,
              builder: (_, NotificationState state) {
                if (state is NotificationLoading) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: ListView.separated(
                          itemCount: 10,
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 16);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 90,
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.05)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                              ),
                            );
                          }));
                }
                if (state is NotificationLoaded) {
                  return mainContent(state.notificationResponseModel.data!);
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Expanded(
                    child: ListView.separated(
                        itemCount: 10,
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 16);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 90,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.05)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                );
              })),
    );
  }

  Widget mainContent(List<Data> data) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: data.length,
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemBuilder: (context, index) {
        DateTime tempDate =
            DateFormat('yyyy-MM-dd').parse(data[index].creDate!);
        return ListTile(
          title: Text(
            data[index].title!,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            data[index].message!,
            style: const TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          trailing: SizedBox(
            height: double.infinity,
            child: Text(
              timeago.format(tempDate),
              style: const TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        );
      },
    );
  }
}
