import 'package:equatable/equatable.dart';
import 'package:mobile_collection/feature/invoice_detail/data/attachment_preview_model.dart';

abstract class AttachmentPreviewState extends Equatable {
  const AttachmentPreviewState();

  @override
  List<Object> get props => [];
}

class AttachmentPreviewInitial extends AttachmentPreviewState {}

class AttachmentPreviewLoading extends AttachmentPreviewState {}

class AttachmentPreviewLoaded extends AttachmentPreviewState {
  const AttachmentPreviewLoaded({required this.attachmentPreviewModel});
  final AttachmentPreviewModel attachmentPreviewModel;

  @override
  List<Object> get props => [attachmentPreviewModel];
}

class AttachmentPreviewError extends AttachmentPreviewState {
  const AttachmentPreviewError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AttachmentPreviewException extends AttachmentPreviewState {
  const AttachmentPreviewException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
