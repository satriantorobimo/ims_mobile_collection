import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_collection/components/color_comp.dart';
import 'package:mobile_collection/feature/assignment/data/task_list_response_model.dart';
import 'package:mobile_collection/feature/invoice_detail/bloc/update_bloc/bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/bloc/upload_bloc/bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/upload_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/repo/update_repo.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:mobile_collection/utility/drop_down_util.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/network_util.dart';
import 'package:mobile_collection/utility/string_router_util.dart';
import 'package:path/path.dart' as path;

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key, required this.agreementList});

  final AgreementList agreementList;

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  late List<String> filterValue = [
    'PAID',
    'ALREADY PAID',
    'PROMISE',
    'NOT PAID',
    'NOT FOUND'
  ];
  late List<CustDropdownMenuItem> filter = [];
  String paidAmountValue = '';
  TextEditingController ctrlAmount = TextEditingController();
  TextEditingController ctrlRemark = TextEditingController();
  TextEditingController ctrlDate = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String dateSend = '';
  String dateAttach = '';
  String dueDate = '';
  String collCode = '';
  var filterSelect = 0;
  List<AttachmentList> attachment = [];
  List<UploadRequestModel> uploadRequestModel = [];
  bool isLoading = false;
  UpdateRequestModel updateRequestModel = UpdateRequestModel();
  UploadBloc uploadBloc = UploadBloc(updateRepo: UpdateRepo());
  UpdateBloc updateBloc = UpdateBloc(updateRepo: UpdateRepo());
  bool isReadAmt = false;
  bool isReadRemark = false;
  bool isReadStatus = false;
  bool isReadDate = false;
  final InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker();

  Future<void> getStatus() async {
    setState(() {
      filter.add(const CustDropdownMenuItem(
          value: 0, data: 'PAID', child: Text("PAID")));
      filter.add(const CustDropdownMenuItem(
          value: 1, data: 'ALREADY PAID', child: Text("ALREADY PAID")));
      filter.add(const CustDropdownMenuItem(
          value: 2, data: 'PROMISE', child: Text("PROMISE")));
      filter.add(const CustDropdownMenuItem(
          value: 3, data: 'NOT PAID', child: Text("NOT PAID")));
      filter.add(const CustDropdownMenuItem(
          value: 4, data: 'NOT FOUND', child: Text("NOT FOUND")));
      if (widget.agreementList.resultCode != '') {
        int index = filter.indexWhere((item) =>
            item.data == widget.agreementList.resultCode!.toUpperCase());
        filterSelect = index;
        ctrlAmount.text = GeneralUtil.convertToIdrWithoutSymbol(
            widget.agreementList.resultPaymentAmount!, 2);
        ctrlRemark.text = widget.agreementList.resultRemarks!;
        if (widget.agreementList.resultPromiseDate != '') {
          DateTime tempDate = DateFormat('dd/MM/yyyy')
              .parse(widget.agreementList.resultPromiseDate!);
          dateSend = DateFormat('yyyy-MM-dd').format(tempDate);
          dateAttach = DateFormat('dd MMM, yyyy').format(tempDate);
          ctrlDate.text = dateAttach;
        }
        isReadAmt = true;
        isReadRemark = true;
        isReadStatus = true;
        isReadDate = true;
      }
    });
  }

  Future<void> updateData(UpdateRequestModel data, bool isOffline) async {
    await DatabaseHelper.updateAgreement(
        taskId: widget.agreementList.taskId,
        resultCode: data.pResultCode,
        resultPaymentAmount: data.pResultPaymentAmount.toString(),
        resultPromiseDate: data.pResultPromiseDate,
        resultRemark: data.pResultRemarks,
        isSync: !isOffline ? 0 : 1);

    await DatabaseHelper.insertAttachmentList(
        attachment, widget.agreementList.taskId!);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController!.repeat();
    setState(() {
      dateSend = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      dateAttach = DateFormat('dd MMM, yyyy').format(_selectedDate!);
      if (widget.agreementList.attachmentList != null) {
        attachment.addAll(widget.agreementList.attachmentList!);
      }
      DateTime tempDate = DateFormat('dd-MM-yyyy')
          .parse(widget.agreementList.installmentDueDate!);
      var inputDate = DateTime.parse(tempDate.toString());
      var outputFormat = DateFormat('dd MMMM yyyy');
      dueDate = outputFormat.format(inputDate);
    });
    getStatus();
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final data = await DatabaseHelper.getUserData();
    setState(() {
      collCode = data[0]['uid'];
    });
  }

  void loading(BuildContext context) {
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actionsPadding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Container(),
          titlePadding: const EdgeInsets.only(top: 20, left: 20),
          contentPadding: const EdgeInsets.only(
            top: 0,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    valueColor: animationController!.drive(
                        ColorTween(begin: thirdColor, end: secondaryColor)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Mohon menunggu sebentar',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF575551)),
              ),
            ],
          ),
          actions: const [],
        );
      },
    );
  }

  void goHomeDraft() {
    showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actionsPadding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Container(),
          titlePadding: const EdgeInsets.only(top: 20, left: 20),
          contentPadding: const EdgeInsets.only(
            top: 0,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Center(
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAB7D),
                  size: 80,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Data has been save successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF575551)),
              ),
              SizedBox(height: 16),
              Text(
                'Data status changed to not sync.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF575551)),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringRouterUtil.tabScreenRoute,
                  (route) => false,
                );
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: thirdColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                    child: Text('Ok',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600))),
              ),
            ),
          ],
        );
      },
    );
  }

  void goHome() {
    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actionsPadding:
              const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Container(),
          titlePadding: const EdgeInsets.only(top: 20, left: 20),
          contentPadding: const EdgeInsets.only(
            top: 0,
            bottom: 24,
            left: 24,
            right: 24,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Center(
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAB7D),
                  size: 80,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Data has been sent successfuly',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF575551)),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () async {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  StringRouterUtil.tabScreenRoute,
                  (route) => false,
                );
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: thirdColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                    child: Text('Ok',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600))),
              ),
            ),
          ],
        );
      },
    );
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, StringRouterUtil.amortizationScreenRoute,
                            arguments: widget.agreementList);
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
                    'Select Resource File',
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
                        pickImage(true).then((value) {
                          if (value == 'big') {
                            GeneralUtil()
                                .showSnackBarError(context, 'Size Maximal 5MB');
                          }
                          Navigator.pop(context);
                        });
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
                        pickImage(false).then((value) {
                          if (value == 'big') {
                            GeneralUtil()
                                .showSnackBarError(context, 'Size Maximal 5MB');
                          }
                          Navigator.pop(context);
                        });
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

  Future<String> pickImage(bool isCamera) async {
    try {
      var maxFileSizeInBytes = 5 * 1048576;
      ImagePicker imagePicker = ImagePicker();
      XFile? pickedImage = await imagePicker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 90,
      );
      if (pickedImage == null) return 'notselect';

      var imagePath = await pickedImage.readAsBytes();
      var fileSize = imagePath.length; // Get the file size in bytes
      if (fileSize <= maxFileSizeInBytes) {
        Uint8List imagebytes = await pickedImage.readAsBytes();
        String base64string = base64.encode(imagebytes);
        setState(() {
          attachment.add(AttachmentList(
              taskId: widget.agreementList.taskId!,
              filePath: pickedImage.path,
              ext: path.extension(path.basename(pickedImage.path)),
              fileName: path.basename(pickedImage.path),
              modDate: dateAttach,
              fileSize: fileSize ~/ 1000));
          uploadRequestModel.add(UploadRequestModel(
              pTaskId: widget.agreementList.taskId!,
              pAgreementNo: widget.agreementList.agreementNo,
              pFilePath: widget.agreementList.taskId!,
              pFileName: path.basename(pickedImage.path),
              pFileSize: fileSize ~/ 1000,
              pBase64: base64string));
        });
      } else {
        return 'big';
      }

      return 'yes';
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
      return 'notselect';
    }
  }

  Future<void> showBottomFilter() {
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
                  'Status',
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
                          setState(() {
                            filterSelect = index;
                          });
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
                            filterSelect == index
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

  void submitData(BuildContext context) {
    updateRequestModel.pResultPaymentAmount =
        int.parse(paidAmountValue == '' ? '0' : paidAmountValue);
    updateRequestModel.pResultPromiseDate = dateSend;
    updateRequestModel.pTaskId = widget.agreementList.taskId;
    updateRequestModel.pResultRemarks = ctrlRemark.text;
    updateRequestModel.pResultCode = filterValue[filterSelect];
    loading(context);

    NetworkInfo(internetConnectionChecker).isConnected.then((value) {
      if (value) {
        setState(() {
          updateBloc.add(UpdateAttempt(updateRequestModel, collCode));
        });
      } else {
        setState(() async {
          updateData(updateRequestModel, false).then((value) {
            Navigator.pop(context);
            goHomeDraft();
          });
        });
      }
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
        backgroundColor: const Color(0xFF9BBFB6),
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
                        const Text(
                          'Asset Name',
                          style: TextStyle(
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
                            color: const Color(0xFFFBFBFB),
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agreement No',
                          style: TextStyle(
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
                            color: const Color(0xFFFBFBFB),
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Installment Amount',
                          style: TextStyle(
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
                            color: const Color(0xFFFBFBFB),
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
                                  widget.agreementList.installmentAmount!, 2),
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Installment Due Date',
                          style: TextStyle(
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
                            color: const Color(0xFFFBFBFB),
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
                              dueDate,
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overdue Days',
                          style: TextStyle(
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
                            color: const Color(0xFFFBFBFB),
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
                  const SizedBox(height: 12),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 16,
              color: const Color(0xFFE7E7E7),
            ),
            const SizedBox(height: 12),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Result',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Column(
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
                      GestureDetector(
                        onTap: isReadAmt ? null : showBottomFilter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                              color: isReadAmt
                                  ? Colors.grey.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFFE1E1E1))),
                          child: isReadAmt
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 5),
                                  child: Text(
                                    '${filter[filterSelect].data}',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        filter[filterSelect].data,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                          Icons.keyboard_arrow_down_rounded)
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Visibility(
                    visible: filterSelect == 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Payment Amount',
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
                            height: 45,
                            child: TextFormField(
                              controller: ctrlAmount,
                              keyboardType: TextInputType.number,
                              readOnly: isReadAmt,
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
                              style: TextStyle(
                                  color:
                                      isReadAmt ? Colors.grey : Colors.black),
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
                                  fillColor: isReadAmt
                                      ? Colors.grey.withOpacity(0.1)
                                      : Colors.white,
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
                      visible: filterSelect == 0,
                      child: const SizedBox(height: 12)),
                  Visibility(
                    visible: filterSelect == 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Promise Date',
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
                            height: 45,
                            child: TextFormField(
                              controller: ctrlDate,
                              onTap: isReadDate ? null : _presentDatePicker,
                              keyboardType: TextInputType.text,
                              readOnly: true,
                              style: TextStyle(
                                  color:
                                      isReadAmt ? Colors.grey : Colors.black),
                              decoration: InputDecoration(
                                  hintText: 'Promise Date',
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: isReadAmt
                                      ? Colors.grey.withOpacity(0.1)
                                      : Colors.white,
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
                  const SizedBox(height: 12),
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
                          height: 128,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: 6,
                            readOnly: isReadRemark,
                            controller: ctrlRemark,
                            style: TextStyle(
                                color: isReadAmt ? Colors.grey : Colors.black),
                            decoration: InputDecoration(
                                hintText: 'Remark',
                                isDense: true,
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.5)),
                                filled: true,
                                fillColor: isReadAmt
                                    ? Colors.grey.withOpacity(0.1)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                          !isReadAmt
                              ? GestureDetector(
                                  onTap: isReadAmt
                                      ? null
                                      : () {
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
                              : Container()
                        ],
                      ),
                      const SizedBox(height: 8),
                      attachment.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemCount: attachment.length,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 16);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 75,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFE),
                                      border: Border.all(
                                          color: const Color(0xFFF8FAFE)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (attachment[index].ext != null) {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .imageAssetScreenRoute,
                                                arguments:
                                                    attachment[index].filePath);
                                          } else {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .imageNetworkScreenRoute,
                                                arguments:
                                                    AttachmentPreviewRequestModel(
                                                        pFileName:
                                                            attachment[index]
                                                                .fileName,
                                                        pFilePaths:
                                                            attachment[index]
                                                                .filePath));
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icon/file.svg',
                                              height: 28,
                                              width: 28,
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'File ${attachment[index].fileName!.substring(0, 25)}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '${attachment[index].fileSize} KB . ${attachment[index].modDate}  ',
                                                  style: const TextStyle(
                                                      color: Color(0xFF71839B),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          isReadAmt
                                              ? Container()
                                              : InkWell(
                                                  onTap: () {
                                                    GeneralUtil()
                                                        .showSnackBarDownload(
                                                            context,
                                                            'Download attachment in progress');
                                                    try {
                                                      GallerySaver.saveImage(
                                                              attachment[index]
                                                                  .filePath!)
                                                          .then((path) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentSnackBar;
                                                        GeneralUtil()
                                                            .showSnackBarSuccess(
                                                                context,
                                                                'Download attachment successfully');
                                                      });
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar;
                                                      GeneralUtil()
                                                          .showSnackBarError(
                                                              context,
                                                              e.toString());
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/icon/download.svg',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                          isReadAmt
                                              ? Container()
                                              : const SizedBox(width: 16),
                                          isReadAmt
                                              ? Container()
                                              : InkWell(
                                                  onTap: () {
                                                    if (attachment.length ==
                                                        1) {
                                                      setState(() {
                                                        attachment = [];
                                                      });
                                                    } else {
                                                      setState(() {
                                                        attachment
                                                            .removeAt(index);
                                                      });
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/icon/trash.svg',
                                                    height: 20,
                                                    width: 20,
                                                    color: isReadAmt
                                                        ? Colors.grey
                                                        : Colors.red,
                                                  ),
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              })
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: 123,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFBFBFB),
                                  border: Border.all(
                                      color: const Color(0xFFEAEAEA)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
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
                  const SizedBox(height: 24),
                  MultiBlocListener(
                      listeners: [
                        BlocListener(
                          bloc: updateBloc,
                          listener: (_, UpdateState state) async {
                            if (state is UpdateLoading) {
                              setState(() {
                                isLoading = true;
                              });
                            }
                            if (state is UpdateLoaded) {
                              uploadBloc.add(
                                  UploadAttempt(uploadRequestModel, collCode));
                            }
                            if (state is UpdateError) {
                              Navigator.pop(context);
                              if (!mounted) return;
                              setState(() {
                                isLoading = false;
                              });
                              GeneralUtil()
                                  .showSnackBarError(context, state.error!);
                            }
                            if (state is UpdateException) {
                              Navigator.pop(context);
                              if (!mounted) return;
                              setState(() {
                                isLoading = false;
                              });
                              GeneralUtil()
                                  .showSnackBarError(context, state.error);
                            }
                          },
                        ),
                        BlocListener(
                          bloc: uploadBloc,
                          listener: (_, UploadState state) async {
                            if (state is UploadLoading) {}
                            if (state is UploadLoaded) {
                              Navigator.pop(context);
                              setState(() {
                                isLoading = false;
                              });
                              updateData(updateRequestModel, true)
                                  .then((value) {
                                goHome();
                              });
                            }
                            if (state is UploadError) {
                              Navigator.pop(context);
                              if (!mounted) return;
                              setState(() {
                                isLoading = false;
                              });
                              GeneralUtil()
                                  .showSnackBarError(context, state.error!);
                            }
                            if (state is UploadException) {
                              Navigator.pop(context);
                              if (!mounted) return;
                              setState(() {
                                isLoading = false;
                              });
                              GeneralUtil()
                                  .showSnackBarError(context, state.error);
                            }
                          },
                        )
                      ],
                      child: InkWell(
                        onTap: isLoading ||
                                widget.agreementList.resultCode != ''
                            ? null
                            : () {
                                if (filterValue[filterSelect] == 'PAID') {
                                  if (ctrlRemark.text.isEmpty ||
                                      ctrlRemark.text == '' ||
                                      attachment.isEmpty ||
                                      ctrlAmount.text.isEmpty ||
                                      ctrlAmount.text == '') {
                                    GeneralUtil().showSnackBarError(context,
                                        'Field mandatory may not be empty');
                                  } else {
                                    submitData(context);
                                  }
                                }

                                if (filterValue[filterSelect] == 'PROMISE') {
                                  if (ctrlRemark.text.isEmpty ||
                                      ctrlRemark.text == '' ||
                                      attachment.isEmpty ||
                                      ctrlDate.text.isEmpty ||
                                      ctrlDate.text == '') {
                                    GeneralUtil().showSnackBarError(context,
                                        'Field mandatory may not be empty');
                                  } else {
                                    submitData(context);
                                  }
                                }

                                if (filterValue[filterSelect] == 'NOT PAID' ||
                                    filterValue[filterSelect] == 'NOT FOUND' ||
                                    filterValue[filterSelect] ==
                                        'ALREADY PAID') {
                                  if (filterValue[filterSelect] ==
                                              'NOT FOUND' &&
                                          ctrlRemark.text.isEmpty ||
                                      ctrlRemark.text == '' ||
                                      attachment.isEmpty) {
                                    GeneralUtil().showSnackBarError(context,
                                        'Field mandatory may not be empty');
                                  } else {
                                    submitData(context);
                                  }
                                }
                              },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isLoading ||
                                    widget.agreementList.resultCode != ''
                                ? Colors.grey.withOpacity(0.5)
                                : thirdColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text('SAVE',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: isLoading ||
                                              widget.agreementList.resultCode !=
                                                  ''
                                          ? Colors.grey
                                          : Colors.black,
                                      fontWeight: FontWeight.w600))),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
