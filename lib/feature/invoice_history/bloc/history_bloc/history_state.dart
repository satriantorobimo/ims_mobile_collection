import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_history/data/history_response_model.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded({required this.historyResponseModel});
  final HistoryResponseModel historyResponseModel;

  @override
  List<Object> get props => [historyResponseModel];
}

class HistoryError extends HistoryState {
  const HistoryError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class HistoryException extends HistoryState {
  const HistoryException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
