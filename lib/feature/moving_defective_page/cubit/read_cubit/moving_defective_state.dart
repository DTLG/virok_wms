part of 'moving_defective_cubit.dart';

enum MovingDefectiveStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}

extension MovingDefectiveX on MovingDefectiveStatus {
  bool get isInitial => this == MovingDefectiveStatus.initial;
  bool get isLoading => this == MovingDefectiveStatus.loading;
  bool get isLoaded => this == MovingDefectiveStatus.loaded;
  bool get isError => this == MovingDefectiveStatus.error;
  bool get isSuccess => this == MovingDefectiveStatus.success;
}

class MovingDefectiveState extends Equatable {
  final List<DefectiveNom> noms;
  final MovingDefectiveStatus status;

  final TextEditingController textController;

  MovingDefectiveState({
    this.noms = const [],
    this.status = MovingDefectiveStatus.initial,
  }) : textController = TextEditingController();

  MovingDefectiveState copyWith({
    List<DefectiveNom>? noms,
    MovingDefectiveStatus? status,
  }) {
    return MovingDefectiveState(
      noms: noms ?? this.noms,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [textController, noms, status];
}
