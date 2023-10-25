part of 'selection_order_data_cubit.dart';

enum SelectionOrderDataStatus { initial, loading, success, failure, notFound }

extension SelectionOrderDataStatusX on SelectionOrderDataStatus {
  bool get isInitial => this == SelectionOrderDataStatus.initial;
  bool get isLoading => this == SelectionOrderDataStatus.loading;
  bool get isSuccess => this == SelectionOrderDataStatus.success;
  bool get isFailure => this == SelectionOrderDataStatus.failure;
  bool get isNotFound => this == SelectionOrderDataStatus.notFound;
}

final class SelectionOrderDataState extends Equatable {
  SelectionOrderDataState(
      {this.status = SelectionOrderDataStatus.initial,
      Noms? noms,
      Barcode? barcode,
      this.errorMassage = '',
      this.nomBarcode = '',
      this.itsMezonine = false,
      this.count = 0})
      : noms = noms ?? Noms.empty,
        barcode = barcode ?? Barcode.empty;

  final SelectionOrderDataStatus status;
  final Noms noms;
  final String errorMassage;
  final Barcode barcode;
  final int count;
  final String nomBarcode;
  final bool itsMezonine;

  SelectionOrderDataState copyWith(
      {SelectionOrderDataStatus? status,
      Noms? noms,
      String? errorMassage,
      int? orderStatus,
      Barcode? barcode,
      String? nomBarcode,
      int? count,
      bool? itsMezonine}) {
    return SelectionOrderDataState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        errorMassage: errorMassage ?? this.errorMassage,
        barcode: barcode ?? this.barcode,
        nomBarcode: nomBarcode ?? this.nomBarcode,
        count: count ?? this.count,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, barcode, count, nomBarcode, itsMezonine];
}
