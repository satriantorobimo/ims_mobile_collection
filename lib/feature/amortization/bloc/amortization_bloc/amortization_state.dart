import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/amortization/data/amortization_response_model.dart';

abstract class AmortizationState extends Equatable {
  const AmortizationState();

  @override
  List<Object> get props => [];
}

class AmortizationInitial extends AmortizationState {}

class AmortizationLoading extends AmortizationState {}

class AmortizationLoaded extends AmortizationState {
  const AmortizationLoaded({required this.amortizationResponseModel});
  final AmortizationResponseModel amortizationResponseModel;

  @override
  List<Object> get props => [amortizationResponseModel];
}

class AmortizationError extends AmortizationState {
  const AmortizationError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AmortizationException extends AmortizationState {
  const AmortizationException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
