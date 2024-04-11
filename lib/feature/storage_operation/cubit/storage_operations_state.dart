part of 'storage_operations_cubit.dart';

final class StorageOperationsState extends Equatable {
  const StorageOperationsState({
    this.genBarButton = false,
    this.cellInfoButton = false,
    this.basketInfoButton = false,
    this.itsMezonine = true,
    this.barcodeLablePrintButton = false,
    this.cellGeneratorButton = false,
    this.placementButton = false,
    this.writingOffButton = false
  });

  final bool genBarButton;
  final bool barcodeLablePrintButton;
  final bool cellInfoButton;
  final bool basketInfoButton;
  final bool cellGeneratorButton;
   final bool placementButton;
  final bool writingOffButton;

  final bool itsMezonine;

  StorageOperationsState copyWith(
      {
      bool? genBarButton,
      bool? barcodeLablePrintButton,
      bool? cellInfoButton,
      bool? basketInfoButton,
      bool? cellGeneratorButton,
      bool? writingOffButton,
      bool? placementButton,
      bool? itsMezonine}) {
    return StorageOperationsState(
        genBarButton: genBarButton ?? this.genBarButton,
        cellInfoButton: cellInfoButton ?? this.cellInfoButton,
        barcodeLablePrintButton:
            barcodeLablePrintButton ?? this.barcodeLablePrintButton,
        basketInfoButton: basketInfoButton ?? this.basketInfoButton,
        cellGeneratorButton: cellGeneratorButton ?? this.cellGeneratorButton,
        placementButton: placementButton ?? this.placementButton,
        writingOffButton: writingOffButton ?? this.writingOffButton,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [
        genBarButton,
        barcodeLablePrintButton,
        cellInfoButton,
        basketInfoButton,
        cellGeneratorButton,
        placementButton,
        writingOffButton,
        itsMezonine
      ];
}
