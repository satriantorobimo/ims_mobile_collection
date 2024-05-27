import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/utility/drop_down_util.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/string_router_util.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key, required this.agreementList});
  final AgreementList agreementList;

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late List<String> filterValue = ['PAID', 'PROMISE'];
  late List<CustDropdownMenuItem> filter = [];
  String paidAmountValue = '';
  TextEditingController ctrlAmount = TextEditingController();
  TextEditingController ctrlRemark = TextEditingController();
  TextEditingController ctrlDate = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String dateSend = '';
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
    super.initState();
  }

  Future<void> _showBottomMore(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 24.0, left: 16, right: 16),
                  child: Text(
                    'Select Options',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, StringRouterUtil.invoiceHistoryScreenRoute,
                            arguments: widget.agreementList);
                      },
                      child: const Text(
                        'Invoice History',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, StringRouterUtil.amortizationScreenRoute);
                      },
                      child: const Text(
                        'Amortization ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
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

  Future<void> _showBottomAttachment(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 24.0, left: 16, right: 16),
                  child: Text(
                    'Select Recource File',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.camera_alt_rounded, size: 18),
                          SizedBox(width: 16),
                          Text(
                            'Camera',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.folder_rounded, size: 18),
                          SizedBox(width: 16),
                          Text(
                            'File',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
                onTap: () {
                  _showBottomMore(context);
                },
                child: const Icon(Icons.more_vert_rounded)),
          )
        ],
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Invoice Detail',
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
                              widget.agreementList.vehicleDescription!,
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
                              widget.agreementList.agreementNo!,
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
                              GeneralUtil.convertToIdr(
                                  widget
                                      .agreementList.overdueInstallmentAmount!,
                                  2),
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
                          'Installment Due Date',
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
                              widget.agreementList.installmentDueDate!,
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
                          'Overdue Days',
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
                              widget.agreementList.overdueDays!.toString(),
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
                    'Result',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 4),
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
                          hintText: "Select Status",
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
                  SizedBox(height: 12),
                  Visibility(
                    visible: filterSelect == 0 || filterSelect == 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Amount',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlAmount,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (string) {
                                paidAmountValue = string;
                                string = GeneralUtil.formatNumber(
                                    string.replaceAll('.', ''));
                                ctrlAmount.value = TextEditingValue(
                                  text: string,
                                  selection: TextSelection.collapsed(
                                      offset: string.length),
                                );
                              },
                              decoration: InputDecoration(
                                  prefix: Padding(
                                    padding: const EdgeInsets.only(
                                        right:
                                            4.0), // Adjust the padding as needed
                                    child: Text(GeneralUtil
                                        .currency), // Your prefix text here
                                  ),
                                  hintText: 'Payment Amount',
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: filterSelect == 0 || filterSelect == 1,
                      child: SizedBox(height: 12)),
                  Visibility(
                    visible: filterSelect == 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promise Date',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Material(
                          elevation: 6,
                          shadowColor: Colors.grey.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFFEAEAEA))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: ctrlDate,
                              onTap: _presentDatePicker,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: 'Date of Birth',
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Remark',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Material(
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                                width: 1.0, color: Color(0xFFEAEAEA))),
                        child: SizedBox(
                          width: double.infinity,
                          height: 135,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: 6,
                            controller: ctrlRemark,
                            decoration: InputDecoration(
                                hintText: 'Remark',
                                isDense: true,
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.5)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Attachment',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ' *',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _showBottomAttachment(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/icon/plus.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 123,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xFFFBFBFB),
                            border: Border.all(color: Color(0xFFEAEAEA)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(
                              Icons.camera_alt_outlined,
                              size: 35,
                            )),
                            Text(
                              'No Attachment',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('SAVE',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
