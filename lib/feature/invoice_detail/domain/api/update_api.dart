import 'dart:convert';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/general_response_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/update_request_model.dart';
import 'package:mobile_collection/feature/invoice_detail/data/upload_request_model.dart';
import 'package:mobile_collection/utility/general_util.dart';
import 'package:mobile_collection/utility/shared_pref_util.dart';
import 'package:mobile_collection/utility/url_util.dart';
import 'package:http/http.dart' as http;

class UpdateApi {
  GeneralResponseModel generalResponseModel = GeneralResponseModel();
  AttachmentPreviewModel attachmentPreviewModel = AttachmentPreviewModel();
  final UrlUtil urlUtil = UrlUtil();

  Future<GeneralResponseModel> attemptUpdate(
      UpdateRequestModel updateRequestModel, String collectorCode) async {
    List a = [];
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(collectorCode));
    a.add(updateRequestModel.toJson());

    final json = jsonEncode(a);

    try {
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlUpdate()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        throw generalResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptUpload(
      List<UploadRequestModel> uploadRequestModel, String collectorCode) async {
    GeneralResponseModel generalResponseModels = GeneralResponseModel();
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(collectorCode));

    try {
      for (int i = 0; i < uploadRequestModel.length; i++) {
        List a = [];
        a.add(uploadRequestModel[i].toJson());

        final json = jsonEncode(a);
        Stopwatch stopwatch = Stopwatch()..start();
        final res = await http.post(Uri.parse(urlUtil.getUrlUpload()),
            body: json, headers: header);
        if (res.statusCode == 200) {
          stopwatch.stop();
          generalResponseModels =
              GeneralResponseModel.fromJson(jsonDecode(res.body));
        } else if (res.statusCode == 401) {
          throw 'expired';
        } else {
          generalResponseModel =
              GeneralResponseModel.fromJson(jsonDecode(res.body));
          throw generalResponseModel.message!;
        }
      }
      return generalResponseModels;
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AttachmentPreviewModel> attemptPreview(
      AttachmentPreviewRequestModel attachmentPreviewRequestModel,
      String collectorCode) async {
    final String? token = await SharedPrefUtil.getSharedString('token');

    final Map<String, String> header = urlUtil.getHeaderTypeWithToken(
        token!, GeneralUtil().encodeId(collectorCode));

    try {
      List a = [];
      a.add(attachmentPreviewRequestModel.toJson());

      final json = jsonEncode(a);
      Stopwatch stopwatch = Stopwatch()..start();
      final res = await http.post(Uri.parse(urlUtil.getUrlPreview()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        stopwatch.stop();
        attachmentPreviewModel =
            AttachmentPreviewModel.fromJson(jsonDecode(res.body));
        return attachmentPreviewModel;
      } else if (res.statusCode == 401) {
        throw 'expired';
      } else {
        throw 'exception';
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
