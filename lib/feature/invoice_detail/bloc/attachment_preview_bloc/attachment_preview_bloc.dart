import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/repo/update_repo.dart';
import 'bloc.dart';

class AttachmentPreviewBloc
    extends Bloc<AttachmentPreviewEvent, AttachmentPreviewState> {
  AttachmentPreviewState get initialState => AttachmentPreviewInitial();
  UpdateRepo updateRepo = UpdateRepo();
  AttachmentPreviewBloc({required this.updateRepo})
      : super(AttachmentPreviewInitial()) {
    on<AttachmentPreviewEvent>((event, emit) async {
      if (event is AttachmentPreviewAttempt) {
        try {
          emit(AttachmentPreviewLoading());
          final attachmentPreviewModel = await updateRepo.attemptPreview(
              event.attachmentPreviewRequestModel, event.collectorCode);
          if (attachmentPreviewModel.statusCode == 200) {
            emit(AttachmentPreviewLoaded(
                attachmentPreviewModel: attachmentPreviewModel));
          } else {
            emit(const AttachmentPreviewException('error'));
          }
        } catch (e) {
          emit(AttachmentPreviewException(e.toString()));
        }
      }
    });
  }
}
