import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/feature/amortization/bloc/amortization_bloc/bloc.dart';
import 'package:mobile_collection/feature/amortization/domain/repo/amortization_repo.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:shimmer/shimmer.dart';

class AmortizationScreen extends StatefulWidget {
  const AmortizationScreen({super.key, required this.agreementList});
  final AgreementList agreementList;

  @override
  State<AmortizationScreen> createState() => _AmortizationScreenState();
}

class _AmortizationScreenState extends State<AmortizationScreen> {
  AmortizationBloc amortizationBloc =
      AmortizationBloc(amortizationRepo: AmortizationRepo());

  @override
  void initState() {
    amortizationBloc
        .add(AmortizationAttempt(widget.agreementList.agreementNo!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Amortization',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF9BBFB6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFE7E7E7),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: const Text(
                      'No',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: const Text(
                      'Due Date',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.37,
                    child: const Text(
                      'Installment Amount',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Text(
                      'Paid by',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFE7E7E7),
            ),
            BlocListener(
                bloc: amortizationBloc,
                listener: (_, AmortizationState state) async {
                  if (state is AmortizationLoading) {}
                  if (state is AmortizationLoaded) {}
                  if (state is AmortizationError) {
                    if (!mounted) return;
                    GeneralUtil().showSnackBarError(context, state.error!);
                  }
                  if (state is AmortizationException) {
                    if (!mounted) return;
                    GeneralUtil().showSnackBarError(context, state.error);
                  }
                },
                child: BlocBuilder(
                    bloc: amortizationBloc,
                    builder: (_, AmortizationState state) {
                      if (state is AmortizationLoading) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: 24,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 2);
                                },
                                padding: const EdgeInsets.all(4),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
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
                                }));
                      }
                      if (state is AmortizationLoaded) {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                state.amortizationResponseModel.data!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 2);
                            },
                            padding: const EdgeInsets.all(4),
                            itemBuilder: (BuildContext context, int index) {
                              String dateDue = '';
                              late DateTime tempDateDue;
                              String payDate = '';
                              DateTime? selectedDate = DateTime.now();
                              DateTime dateNows = selectedDate.getDateOnly();
                              if (state.amortizationResponseModel.data![index]
                                      .dueDate !=
                                  '') {
                                DateTime tempDate = DateFormat('dd/MM/yyyy')
                                    .parse(state.amortizationResponseModel
                                        .data![index].dueDate!);
                                DateTime tempDateComp = DateFormat('dd/MM/yyyy')
                                    .parse(state.amortizationResponseModel
                                        .data![index].dueDate!);
                                var inputDate =
                                    DateTime.parse(tempDate.toString());
                                tempDateDue =
                                    DateTime.parse(tempDateComp.toString());
                                var outputFormat = DateFormat('dd MMMM yyyy');

                                dateDue = outputFormat.format(inputDate);
                              }
                              if (state.amortizationResponseModel.data![index]
                                  .paymentList!.isNotEmpty) {
                                DateTime tempDate = DateFormat('dd/MM/yyyy')
                                    .parse(state
                                        .amortizationResponseModel
                                        .data![index]
                                        .paymentList![0]
                                        .paymentDate!);
                                var inputDate =
                                    DateTime.parse(tempDate.toString());
                                var outputFormat = DateFormat('dd MMMM yyyy');
                                payDate = outputFormat.format(inputDate);
                              }
                              log(tempDateDue.toString());
                              log(dateNows.toString());
                              return Container(
                                color: tempDateDue.isBefore(dateNows) &&
                                        state.amortizationResponseModel
                                            .data![index].paymentList!.isEmpty
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 4.0,
                                      bottom: 4.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Text(
                                          '${state.amortizationResponseModel.data![index].installmentNo!}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        child: Text(
                                          dateDue,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        child: Text(
                                          GeneralUtil.convertToIdr(
                                              state
                                                  .amortizationResponseModel
                                                  .data![index]
                                                  .installmentAmount!,
                                              2),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        child: state
                                                .amortizationResponseModel
                                                .data![index]
                                                .paymentList!
                                                .isNotEmpty
                                            ? RichText(
                                                text: TextSpan(
                                                  text:
                                                      '${state.amortizationResponseModel.data![index].paymentList![0].paymentSourceType}\n',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  children: [
                                                    TextSpan(
                                                      text: payDate,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 24,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 2);
                              },
                              padding: const EdgeInsets.all(4),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
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
                              }));
                    })),
          ],
        ),
      ),
    );
  }
}

extension MyDateExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }
}
