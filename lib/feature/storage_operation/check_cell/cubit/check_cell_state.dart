part of 'check_cell_cubit.dart';

enum CheckCellStatus { initial, loading, success, failure, notFound }

extension CheckCellStatusX on CheckCellStatus {
  bool get isInitial => this == CheckCellStatus.initial;
  bool get isLoading => this == CheckCellStatus.loading;
  bool get isSuccess => this == CheckCellStatus.success;
  bool get isFailure => this == CheckCellStatus.failure;
  bool get isNotFound => this == CheckCellStatus.notFound;
}

final class CheckCellState extends Equatable {
  CheckCellState({
    this.status = CheckCellStatus.initial,
    this.errorMassage = '',
    this.time = 0,
    CheckCell? cell,
  }) : cell = cell ?? CheckCell.empty;

  final CheckCellStatus status;
  final CheckCell cell;
  final int time;
  final String errorMassage;

  CheckCellState copyWith(
      {CheckCellStatus? status,
      CheckCell? cell,
      String? errorMassage,
      int? time,
}) {
    return CheckCellState(
        status: status ?? this.status,
        cell: cell ?? this.cell,
        time: time ?? this.time,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, cell, errorMassage, ];
}
