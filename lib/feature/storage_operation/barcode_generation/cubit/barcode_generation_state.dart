part of 'barcode_generation_cubit.dart';

enum BarcodeGenerationStatus { initial, loading, success, failure, error }

extension BarcodeGenerationStatusStatusX on BarcodeGenerationStatus {
  bool get isInitial => this == BarcodeGenerationStatus.initial;
  bool get isLoading => this == BarcodeGenerationStatus.loading;
  bool get isSuccess => this == BarcodeGenerationStatus.success;
  bool get isFailure => this == BarcodeGenerationStatus.failure;
  bool get isError => this == BarcodeGenerationStatus.error;
}

final class BarcodeGenerationState extends Equatable {
  BarcodeGenerationState(
      {this.status = BarcodeGenerationStatus.initial,
      this.errorMassage = '',
      this.searchValue = '',
      Noms? noms})
      : noms = noms ?? Noms.empty;

  final BarcodeGenerationStatus status;
  final Noms noms;
  final String errorMassage;
  final String searchValue;

  BarcodeGenerationState copyWith(
      {BarcodeGenerationStatus? status,
      Noms? noms,
      String? errorMassage,
      String? searchValue}) {
    return BarcodeGenerationState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        errorMassage: errorMassage ?? this.errorMassage,
        searchValue: searchValue ?? this.searchValue);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, searchValue];
}
