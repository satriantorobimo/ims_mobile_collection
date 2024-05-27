import 'package:equatable/equatable.dart';

abstract class AmortizationEvent extends Equatable {
  const AmortizationEvent();
}

class AmortizationAttempt extends AmortizationEvent {
  const AmortizationAttempt(this.agreementNo);
  final String agreementNo;

  @override
  List<Object> get props => [agreementNo];
}
