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
      Nom? nom,
      Barcode? barcode,
      this.errorMassage = '',
      this.basketStatus = false,
      this.nomBarcode = '',
      this.itsMezonine = false,
       this.basket = '',
      this.cellBarcode = '',
      this.time = 0,
      this.count = 0})
      : noms = noms ?? Noms.empty,
        barcode = barcode ?? Barcode.empty,
        nom = nom ?? Nom.empty;

  final SelectionOrderDataStatus status;
  final Noms noms;
  final Nom nom;
  final bool basketStatus;
  final String errorMassage;
  final Barcode barcode;
  final String basket;
  final double count;
  final String cellBarcode;
  final String nomBarcode;
  final bool itsMezonine;
  final int time;

  SelectionOrderDataState copyWith(
      {SelectionOrderDataStatus? status,
      Noms? noms,
      Nom? nom,
      String? errorMassage,
      int? orderStatus,
      Barcode? barcode,
      String? nomBarcode,
      bool? basketStatus,
      String? cellBarcode,
      String? basket,
      double? count,
      bool? itsMezonine, int? time}) {
    return SelectionOrderDataState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        nom: nom ?? this.nom,
        basket: basket ?? this.basket,
        errorMassage: errorMassage ?? this.errorMassage,
        basketStatus: basketStatus ?? this.basketStatus,
        barcode: barcode ?? this.barcode,
        nomBarcode: nomBarcode ?? this.nomBarcode,
        cellBarcode: cellBarcode ?? this.cellBarcode,
        count: count ?? this.count,
        itsMezonine: itsMezonine ?? this.itsMezonine,
        time: time ?? this.time);
  }

  @override
  List<Object?> get props => [
        status,
        noms,
        nom,
        errorMassage,
        barcode,
        count,
        nomBarcode,
        itsMezonine,
        cellBarcode,
        basketStatus,
        basket,
        time
      ];
}
