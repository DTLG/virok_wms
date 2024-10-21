part of 'writing_off_cubit.dart';

enum WritingOffStatus { initial, loading, success, failure, notFound }

extension WritingOffStatusX on WritingOffStatus {
  bool get isInitial => this == WritingOffStatus.initial;
  bool get isLoading => this == WritingOffStatus.loading;
  bool get isSuccess => this == WritingOffStatus.success;
  bool get isFailure => this == WritingOffStatus.failure;
  bool get isNotFound => this == WritingOffStatus.notFound;
}

final class WritingOffState extends Equatable {
  const WritingOffState(
      {this.status = WritingOffStatus.initial,
      this.count = 0,
      this.qty = 0,
      this.cellStatus = 1,
      this.cellBarcode = '',
      this.article = '',
      this.name = '',
      this.error = '',
      Cell? cell,
      this.nomBarcode = ''})
      : cell = cell ?? Cell.empty;

  final WritingOffStatus status;
  final Cell cell;
  final String cellBarcode;
  final String nomBarcode;
  final String name;
  final int count;
  final int qty;
  final String article;
  final int cellStatus;
  final String error;

  WritingOffState copyWith(
      {WritingOffStatus? status,
      Cell? cell,
      String? nomBarcode,
      String? cellBarcode,
      String? name,
      String? article,
      String? error,
      int? count,
      int? qty,
      int? cellStatus}) {
    return WritingOffState(
        status: status ?? this.status,
        cell: cell ?? this.cell,
        nomBarcode: nomBarcode ?? this.nomBarcode,
        cellBarcode: cellBarcode ?? this.cellBarcode,
        article: article ?? this.article,
        name: name ?? this.name,
        count: count ?? this.count,
        cellStatus: cellStatus ?? this.cellStatus,
        qty: qty ?? this.qty,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [
        status,
        cell,
        nomBarcode,
        count,
        cellStatus,
        name,
        cellBarcode,
        error,
        qty,
        article
      ];
}
