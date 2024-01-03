part of 'nom_operations_cubit.dart';

enum NomOperationsStatus { initial, loading, success, failure, error }

extension NomOperationsStatusX on NomOperationsStatus {
  bool get isInitial => this == NomOperationsStatus.initial;
  bool get isLoading => this == NomOperationsStatus.loading;
  bool get isSuccess => this == NomOperationsStatus.success;
  bool get isFailure => this == NomOperationsStatus.failure;
  bool get isError => this == NomOperationsStatus.error;
}

final class NomOperationsState extends Equatable {
  const NomOperationsState(
      {this.status = NomOperationsStatus.initial,
      this.errorMassage = '',
      this.barcodeGenerationButton = false,
      this.barcodeLablePrintButton = false,
      BarcodesNom? nom})
      : nom = nom ?? BarcodesNom.empty;

  final NomOperationsStatus status;
  final BarcodesNom nom;
  final String errorMassage;
  final bool barcodeGenerationButton;
    final bool barcodeLablePrintButton;


  NomOperationsState copyWith(
      {NomOperationsStatus? status,
      BarcodesNom? nom,
      String? errorMassage,
      bool? barcodeGenerationButton,
      bool?  barcodeLablePrintButton

}) {
    return NomOperationsState(
        status: status ?? this.status,
        nom: nom ?? this.nom,
        errorMassage: errorMassage ?? this.errorMassage,
        barcodeGenerationButton: barcodeGenerationButton ?? this.barcodeGenerationButton,
        barcodeLablePrintButton: barcodeLablePrintButton ?? this.barcodeLablePrintButton);
  }

  @override
  List<Object?> get props => [status, nom, errorMassage, barcodeGenerationButton,barcodeLablePrintButton];
}
