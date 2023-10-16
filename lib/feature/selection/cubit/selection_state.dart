part of 'selection_cubit.dart';

enum SelectionStatus { initial, loading, success, failure, notFound }

extension SelectionStatusX on SelectionStatus {
  bool get isInitial => this == SelectionStatus.initial;
  bool get isLoading => this == SelectionStatus.loading;
  bool get isSuccess => this == SelectionStatus.success;
  bool get isFailure => this == SelectionStatus.failure;
  bool get isNotFound => this == SelectionStatus.notFound;
}

final class SelectionState extends Equatable {
  SelectionState(
      {this.status = SelectionStatus.initial,
      this.containerBar = '',
      this.count = '',
      this.lastNom = '',
      this.cell = '',
      Noms? noms})
      : noms = noms ?? Noms.empty;

  final SelectionStatus status;
  final Noms noms;
  final String containerBar;
  final String count;
  final String lastNom;
    final String cell;


  SelectionState copyWith(
      {SelectionStatus? status,
      Noms? noms,
      String? containerBar,
      String? count,
      String? lastNom,
            String? cell

      }) {
    return SelectionState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        containerBar: containerBar ?? this.containerBar,
        count: count ?? this.count,
        lastNom: lastNom ?? this.lastNom,
        cell: cell ?? this.cell
        );
  }

  @override
  List<Object?> get props => [status, noms, containerBar, count, lastNom, cell];
}
