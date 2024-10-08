part of 'table_state_cubit.dart';

enum TableStatus { initial, loading, success, failure, notFound }

extension TableStatusX on TableStatus {
  bool get isInitial => this == TableStatus.initial;
  bool get isLoading => this == TableStatus.loading;
  bool get isSuccess => this == TableStatus.success;
  bool get isFailure => this == TableStatus.failure;
  bool get isNotFound => this == TableStatus.notFound;
}

class CustomTableState extends Equatable {
  final List<Nom> noms;
  final TableStatus status;
  final int scrollIndex;
  // final ScrollController scrollController;

  const CustomTableState({
    required this.noms,
    this.scrollIndex = 0,
    this.status = TableStatus.initial,
  });

  CustomTableState copyWith({
    List<Nom>? noms,
    int? scrollIndex,
    TableStatus? status,
  }) {
    return CustomTableState(
      noms: noms ?? this.noms,
      scrollIndex: scrollIndex ?? this.scrollIndex,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [noms, scrollIndex, status];
}
