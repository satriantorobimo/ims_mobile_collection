import 'dart:io';
import 'package:flutter/material.dart';

class AttachmentPreviewAssetScreen extends StatefulWidget {
  final String path;
  const AttachmentPreviewAssetScreen(this.path, {super.key});

  @override
  State<AttachmentPreviewAssetScreen> createState() =>
      _AttachmentPreviewAssetScreenState();
}

class _AttachmentPreviewAssetScreenState
    extends State<AttachmentPreviewAssetScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                mainContent(widget.path),
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
      child: Image.file(
        File(value),
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
