import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_collection/feature/amortization/domain/repo/amortization_repo.dart';
import 'bloc.dart';

class AmortizationBloc extends Bloc<AmortizationEvent, AmortizationState> {
  AmortizationState get initialState => AmortizationInitial();
  AmortizationRepo amortizationRepo = AmortizationRepo();
  AmortizationBloc({required this.amortizationRepo})
      : super(AmortizationInitial()) {
    on<AmortizationEvent>((event, emit) async {
      if (event is AmortizationAttempt) {
        try {
          emit(AmortizationLoading());
          final amortizationResponseModel =
              await amortizationRepo.attemptAmortization(event.agreementNo);
          if (amortizationResponseModel.result == 1) {
            emit(AmortizationLoaded(
                amortizationResponseModel: amortizationResponseModel));
          } else if (amortizationResponseModel.result == 0) {
            emit(AmortizationError(amortizationResponseModel.message));
          } else {
            emit(const AmortizationException('error'));
          }
        } catch (e) {
          emit(AmortizationException(e.toString()));
        }
      }
    });
  }
}
