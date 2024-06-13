import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_detail/data/general_response_model.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadLoaded extends UploadState {
  const UploadLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;

  @override
  List<Object> get props => [generalResponseModel];
}

class UploadError extends UploadState {
  const UploadError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UploadException extends UploadState {
  const UploadException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
