import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_detail/data/general_response_model.dart';

abstract class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

class UpdateInitial extends UpdateState {}

class UpdateLoading extends UpdateState {}

class UpdateLoaded extends UpdateState {
  const UpdateLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;

  @override
  List<Object> get props => [generalResponseModel];
}

class UpdatePersonalLoaded extends UpdateState {
  const UpdatePersonalLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;

  @override
  List<Object> get props => [generalResponseModel];
}

class UpdateError extends UpdateState {
  const UpdateError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UpdateException extends UpdateState {
  const UpdateException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
