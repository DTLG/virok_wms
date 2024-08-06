part of 'moving_in_cells_cubit.dart';

enum MovingInCellsStatus {
  initial,
  loading,
  success,
  failure,
  notFound,
  placement
}

extension MovingInCellsStatusX on MovingInCellsStatus {
  bool get isInitial => this == MovingInCellsStatus.initial;
  bool get isLoading => this == MovingInCellsStatus.loading;
  bool get isSuccess => this == MovingInCellsStatus.success;
  bool get isFailure => this == MovingInCellsStatus.failure;
  bool get isNotFound => this == MovingInCellsStatus.notFound;
  bool get isPlacement => this == MovingInCellsStatus.placement;
}

final class MovingInCellsState extends Equatable {
  MovingInCellsState({
    this.status = MovingInCellsStatus.initial,
    this.errorMassage = '',
    this.cellPut = '',
    this.cellTake = '',
    this.cellTakeName = '',
    this.count = 0,
    this.time = 0,
    this.isPlacement = false,
    this.nomStatus = 'Кондиція',
    Nom? nom,
    CheckCell? cell,
  })  : cell = cell ?? CheckCell.empty,
        nom = nom ?? Nom.empty;

  final MovingInCellsStatus status;
  final CheckCell cell;
  final int time;
  final String errorMassage;
  final double count;
  final String cellTake;
  final String cellTakeName;
  final String cellPut;
  final Nom nom;
  final bool isPlacement;
  final String nomStatus;

  MovingInCellsState copyWith(
      {MovingInCellsStatus? status,
      CheckCell? cell,
      String? errorMassage,
      int? time,
      double? count,
      String? cellTake,
      String? cellTakeName,
      String? cellPut,
      Nom? nom,
      bool? isPlacement,
      String? nomStatus}) {
    return MovingInCellsState(
        status: status ?? this.status,
        cell: cell ?? this.cell,
        time: time ?? this.time,
        errorMassage: errorMassage ?? this.errorMassage,
        count: count ?? this.count,
        cellTake: cellTake ?? this.cellTake,
        cellTakeName: cellTakeName ?? this.cellTakeName,
        cellPut: cellPut ?? this.cellPut,
        nom: nom ?? this.nom,
        isPlacement: isPlacement ?? this.isPlacement,
        nomStatus: nomStatus ?? this.nomStatus);
  }

  @override
  List<Object?> get props => [
        status,
        cell,
        errorMassage,
        count,
        cellPut,
        cellTake,
        nom,
        isPlacement,
        time,
        cellTakeName,
        nomStatus
      ];
}
