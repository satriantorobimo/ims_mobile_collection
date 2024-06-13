import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/repo/update_repo.dart';
import 'bloc.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadState get initialState => UploadInitial();
  UpdateRepo updateRepo = UpdateRepo();
  UploadBloc({required this.updateRepo}) : super(UploadInitial()) {
    on<UploadEvent>((event, emit) async {
      if (event is UploadAttempt) {
        try {
          emit(UploadLoading());
          final generalResponseModel = await updateRepo.attemptUpload(
              event.uploadRequestModel, event.collectorCode);
          if (generalResponseModel.result == 1) {
            emit(UploadLoaded(generalResponseModel: generalResponseModel));
          } else if (generalResponseModel.result == 0) {
            emit(UploadError(generalResponseModel.message));
          } else {
            emit(const UploadException('error'));
          }
        } catch (e) {
          emit(UploadException(e.toString()));
        }
      }
    });
  }
}
