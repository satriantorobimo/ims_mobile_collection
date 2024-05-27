import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
}

class HistoryAttempt extends HistoryEvent {
  const HistoryAttempt(this.agreementNo);
  final String agreementNo;

  @override
  List<Object> get props => [agreementNo];
}
