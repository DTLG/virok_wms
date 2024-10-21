part of 'docs_defect_cubit.dart';

enum DocsDefectStatus {
  initial,
  loading,
  loaded,
  error,
}

extension DocsDefectStatusX on DocsDefectStatus {
  bool get isInitial => this == DocsDefectStatus.initial;
  bool get isLoading => this == DocsDefectStatus.loading;
  bool get isLoaded => this == DocsDefectStatus.loaded;
  bool get isError => this == DocsDefectStatus.error;
}

class DocsDefectState extends Equatable {
  final DocsDefectStatus status;
  final String erorrMessage;
  final List<ServiceMovingDoc> docs;

  DocsDefectState({
    this.status = DocsDefectStatus.initial,
    this.erorrMessage = '',
    this.docs = const [],
  });

  DocsDefectState copyWith({
    DocsDefectStatus? status,
    String? erorrMessage,
    List<ServiceMovingDoc>? docs,
  }) {
    return DocsDefectState(
      status: status ?? this.status,
      erorrMessage: erorrMessage ?? this.erorrMessage,
      docs: docs ?? this.docs,
    );
  }

  @override
  List<Object?> get props => [
        status,
        docs,
        erorrMessage,
      ];
}
