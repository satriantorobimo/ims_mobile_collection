import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/feature/invoice_history/bloc/history_bloc/bloc.dart';
import 'package:mobile_collection/feature/invoice_history/domain/repo/history_repo.dart';
import 'package:mobile_collection/utility/drop_down_util.dart';
import 'package:mobile_collection/utility/general_util.dart';

class InvoiceHistoryScreen extends StatefulWidget {
  const InvoiceHistoryScreen({super.key, required this.agreementList});
  final AgreementList agreementList;

  @override
  State<InvoiceHistoryScreen> createState() => _InvoiceHistoryScreenState();
}

class _InvoiceHistoryScreenState extends State<InvoiceHistoryScreen> {
  late List<String> filterValue = ['PAID', 'PROMISE'];
  late List<CustDropdownMenuItem> filter = [];
  String paidAmountValue = '';
  TextEditingController ctrlAmount = TextEditingController();
  TextEditingController ctrlRemark = TextEditingController();
  TextEditingController ctrlDate = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String dateSend = '';
  HistoryBloc historyBloc = HistoryBloc(historyRepo: HistoryRepo());
  var filterSelect = 0;
  Future<void> getStatus() async {
    setState(() {
      filter.add(const CustDropdownMenuItem(value: 0, child: Text("PAID")));
      filter.add(
          const CustDropdownMenuItem(value: 1, child: Text("ALREADY PAID")));
      filter.add(const CustDropdownMenuItem(value: 2, child: Text("PROMISE")));
      filter.add(const CustDropdownMenuItem(value: 3, child: Text("NOT PAID")));
      filter
          .add(const CustDropdownMenuItem(value: 4, child: Text("NOT FOUND")));
    });
  }

  @override
  void initState() {
    getStatus();
    historyBloc.add(HistoryAttempt(widget.agreementList.agreementNo!));
    super.initState();
  }

  void _presentDatePicker() {
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 7)),
            firstDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        setState(() {
          ctrlDate.text = DateFormat('dd MMMM yyyy').format(_selectedDate!);
          dateSend = DateFormat('yyyy-MM-dd').format(_selectedDate!);
        });
      });
    });
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
          'Invoice History',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF9BBFB6),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Detail',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Asset Name',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            color: Color(0xFFFBFBFB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                          ),
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Honda HR-V SE CVT',
                              style: const TextStyle(
                                  color: Color(0xFF565656),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agreement No',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            color: Color(0xFFFBFBFB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                          ),
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '0000240300057',
                              style: const TextStyle(
                                  color: Color(0xFF565656),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Installment Amount',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.1)),
                            color: Color(0xFFFBFBFB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                          ),
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Rp. 7.000.000,00',
                              style: const TextStyle(
                                  color: Color(0xFF565656),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: Color(0xFFE7E7E7),
            ),
            SizedBox(height: 12),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collection History',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  BlocListener(
                      bloc: historyBloc,
                      listener: (_, HistoryState state) async {
                        if (state is HistoryLoading) {}
                        if (state is HistoryLoaded) {}
                        if (state is HistoryError) {}
                        if (state is HistoryException) {}
                      },
                      child: BlocBuilder(
                          bloc: historyBloc,
                          builder: (_, HistoryState state) {
                            if (state is HistoryLoading) {
                              return Container();
                            }
                            if (state is HistoryLoaded) {
                              return ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 12);
                                },
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.historyResponseModel.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {},
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
                                                        color: state
                                                                    .historyResponseModel
                                                                    .data![
                                                                        index]
                                                                    .resultCode! ==
                                                                'PAID'
                                                            ? Color(0xFF70B96E)
                                                            : Color(0xFFFF6C6C),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  18.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8.0),
                                                        )),
                                                    child: Center(
                                                      child: Text(
                                                        state
                                                                    .historyResponseModel
                                                                    .data![
                                                                        index]
                                                                    .resultCode! ==
                                                                ''
                                                            ? '-'
                                                            : state
                                                                .historyResponseModel
                                                                .data![index]
                                                                .resultCode!,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )),
                                              Positioned(
                                                  right: 16,
                                                  bottom: 16,
                                                  child: Text(
                                                    '2',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    right: 16.0,
                                                    bottom: 16.0,
                                                    top: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Field Coll',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    const SizedBox(height: 16),
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
                                                                'Budi',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xFF222222)),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .calendar_today_rounded,
                                                                    size: 13,
                                                                    color: Color(
                                                                        0xFF222222),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  Text(
                                                                    '19 - 04 - 2024',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Color(
                                                                            0xFF222222)),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                'Rp. 50.000.000',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xFF222222)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.42,
                                                          child: Text(
                                                            'This is remark for remark for rem...',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xFF222222)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )));
                                },
                              );
                            }
                            return Container();
                          })),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
