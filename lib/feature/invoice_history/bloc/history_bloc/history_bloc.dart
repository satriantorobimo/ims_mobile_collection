import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/invoice_history/domain/repo/history_repo.dart';
import 'bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryState get initialState => HistoryInitial();
  HistoryRepo historyRepo = HistoryRepo();
  HistoryBloc({required this.historyRepo}) : super(HistoryInitial()) {
    on<HistoryEvent>((event, emit) async {
      if (event is HistoryAttempt) {
        try {
          emit(HistoryLoading());
          final historyResponseModel =
              await historyRepo.attemptHistory(event.agreementNo);
          if (historyResponseModel.result == 1) {
            emit(HistoryLoaded(historyResponseModel: historyResponseModel));
          } else if (historyResponseModel.result == 0) {
            emit(HistoryError(historyResponseModel.message));
          } else {
            emit(const HistoryException('error'));
          }
        } catch (e) {
          emit(HistoryException(e.toString()));
        }
      }
    });
  }
}
