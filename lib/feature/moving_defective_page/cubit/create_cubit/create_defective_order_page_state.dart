part of 'create_defective_order_page_cubit.dart';

enum CreateDefectiveOrderPageStatus {
  initial,
  loading,
  loaded,
  error,
}

extension CreateDefectiveOrderPageX on CreateDefectiveOrderPageStatus {
  bool get isInitial => this == CreateDefectiveOrderPageStatus.initial;
  bool get isLoading => this == CreateDefectiveOrderPageStatus.loading;
  bool get isLoaded => this == CreateDefectiveOrderPageStatus.loaded;
  bool get isError => this == CreateDefectiveOrderPageStatus.error;
}

class CreateDefectiveOrderPageState extends Equatable {
  final CreateDefectiveOrderPageStatus status;
  final List<DefectiveNom> noms;
  final TextEditingController textController;

  CreateDefectiveOrderPageState({
    this.status = CreateDefectiveOrderPageStatus.initial,
    this.noms = const [],
    TextEditingController? textController,
  }) : textController = textController ?? TextEditingController();

  CreateDefectiveOrderPageState copyWith({
    List<DefectiveNom>? noms,
    CreateDefectiveOrderPageStatus? status,
    TextEditingController? textController,
  }) {
    return CreateDefectiveOrderPageState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      textController: textController ?? this.textController,
    );
  }

  @override
  List<Object?> get props => [textController, noms, status];
}
