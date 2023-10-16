part of 'barcode_lable_print_cubit.dart';


enum BarcodeLablePrintStatus { initial, loading, success, failure, error }

extension BarcodeLablePrintStatusX on BarcodeLablePrintStatus {
  bool get isInitial => this == BarcodeLablePrintStatus.initial;
  bool get isLoading => this == BarcodeLablePrintStatus.loading;
  bool get isSuccess => this == BarcodeLablePrintStatus.success;
  bool get isFailure => this == BarcodeLablePrintStatus.failure;
  bool get isError => this == BarcodeLablePrintStatus.error;

}

final class BarcodeLablePrintState extends Equatable {
  BarcodeLablePrintState(
      {this.status = BarcodeLablePrintStatus.initial, this.errorMassage = '', BarcodesNoms? noms})
      : noms = noms ?? BarcodesNoms.empty;

  final BarcodeLablePrintStatus status;
  final BarcodesNoms noms;
  final String errorMassage;

  BarcodeLablePrintState copyWith({BarcodeLablePrintStatus? status, BarcodesNoms? noms,String? errorMassage}) {
    return BarcodeLablePrintState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      errorMassage: errorMassage ?? this.errorMassage
    );
  }

  @override
  List<Object?> get props => [status, noms, errorMassage];
}
