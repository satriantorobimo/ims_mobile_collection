import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/bloc/attachment_preview_bloc/bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/repo/update_repo.dart';
import 'package:mobile_collection/utility/database_helper.dart';

class AttachmentPreviewImageScreen extends StatefulWidget {
  final AttachmentPreviewRequestModel attachmentPreviewRequestModel;
  const AttachmentPreviewImageScreen(this.attachmentPreviewRequestModel,
      {super.key});

  @override
  State<AttachmentPreviewImageScreen> createState() =>
      _AttachmentPreviewImageScreenState();
}

class _AttachmentPreviewImageScreenState
    extends State<AttachmentPreviewImageScreen> {
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
                      if (state is AttachmentPreviewLoaded) {}
                      if (state is AttachmentPreviewError) {}
                      if (state is AttachmentPreviewException) {
                        if (state.error == 'expired') {
                          // _sessionExpired();
                        }
                      }
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
                            return mainContent(
                                state.attachmentPreviewModel.value!.data!);
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

  Widget mainContent(String value) {
    return Center(
      child: Image.memory(
        base64Decode(value),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
