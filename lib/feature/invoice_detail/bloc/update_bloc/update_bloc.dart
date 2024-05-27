import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/invoice_detail/domain/repo/update_repo.dart';
import 'bloc.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateState get initialState => UpdateInitial();
  UpdateRepo updateRepo = UpdateRepo();
  UpdateBloc({required this.updateRepo}) : super(UpdateInitial()) {
    on<UpdateEvent>((event, emit) async {
      if (event is UpdateAttempt) {
        try {
          emit(UpdateLoading());
          final generalResponseModel = await updateRepo.attemptUpdate(
              event.updateRequestModel, event.collectorCode);
          if (generalResponseModel.result == 1) {
            emit(UpdateLoaded(generalResponseModel: generalResponseModel));
          } else if (generalResponseModel.result == 0) {
            emit(UpdateError(generalResponseModel.message));
          } else {
            emit(const UpdateException('error'));
          }
        } catch (e) {
          emit(UpdateException(e.toString()));
        }
      }
    });
  }
}
