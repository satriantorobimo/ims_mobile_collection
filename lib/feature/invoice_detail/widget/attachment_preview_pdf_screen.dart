import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/repo/update_repo.dart';
import 'package:mobile_collection/utility/database_helper.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../bloc/attachment_preview_bloc/bloc.dart';

class AttachmentPreviewPdfScreen extends StatefulWidget {
  final AttachmentPreviewRequestModel attachmentPreviewRequestModel;
  const AttachmentPreviewPdfScreen(this.attachmentPreviewRequestModel,
      {super.key});

  @override
  State<AttachmentPreviewPdfScreen> createState() =>
      _AttachmentPreviewPdfScreenState();
}

class _AttachmentPreviewPdfScreenState
    extends State<AttachmentPreviewPdfScreen> {
  AttachmentPreviewBloc docPreviewBloc =
      AttachmentPreviewBloc(updateRepo: UpdateRepo());

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    final datas = await DatabaseHelper.getUserData();
    docPreviewBloc.add(AttachmentPreviewAttempt(
        widget.attachmentPreviewRequestModel, datas[0]['uid']));
  }

  createPdf(String base64pdf, String fileName) async {
    var bytes = base64Decode(base64pdf.replaceAll('\n', ''));
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await OpenFile.open("${output.path}/$fileName");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocListener(
                    bloc: docPreviewBloc,
                    listener: (_, AttachmentPreviewState state) {
                      if (state is AttachmentPreviewLoaded) {
                        createPdf(state.attachmentPreviewModel.value!.data!,
                            state.attachmentPreviewModel.value!.filename!);
                      }
                      if (state is AttachmentPreviewError) {}
                    },
                    child: BlocBuilder(
                        bloc: docPreviewBloc,
                        builder: (_, AttachmentPreviewState state) {
                          if (state is AttachmentPreviewLoading) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 60.0),
                              child: Center(
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }
                          if (state is AttachmentPreviewLoaded) {
                            return Container();
                          }
                          if (state is AttachmentPreviewError) {
                            return Container();
                          }
                          return Container();
                        })),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Center(
                      child: Text(
                        'BACK',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
