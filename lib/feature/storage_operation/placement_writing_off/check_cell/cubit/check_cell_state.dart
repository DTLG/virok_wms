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
  const CheckCellState({
    this.status = CheckCellStatus.initial,
    this.errorMassage = '',
    Cell? cell,
  }) : cell = cell ?? Cell.empty;

  final CheckCellStatus status;
  final Cell cell;
  final String errorMassage;

  CheckCellState copyWith(
      {CheckCellStatus? status, Cell? cell, String? errorMassage}) {
    return CheckCellState(
        status: status ?? this.status,
        cell: cell ?? this.cell,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, cell, errorMassage];
}
