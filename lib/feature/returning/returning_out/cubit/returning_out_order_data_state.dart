part of 'returning_out_order_data_cubit.dart';

enum ReturningOutOrderDataStatus {
  initial,
  loading,
  success,
  failure,
  notFound
}

extension ReturningOrderDataStatusX on ReturningOutOrderDataStatus {
  bool get isInitial => this == ReturningOutOrderDataStatus.initial;
  bool get isLoading => this == ReturningOutOrderDataStatus.loading;
  bool get isSuccess => this == ReturningOutOrderDataStatus.success;
  bool get isFailure => this == ReturningOutOrderDataStatus.failure;
  bool get isNotFound => this == ReturningOutOrderDataStatus.notFound;
}

final class ReturningOutOrderDataState extends Equatable {
  ReturningOutOrderDataState(
      {this.status = ReturningOutOrderDataStatus.initial,
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

  final ReturningOutOrderDataStatus status;
  final Noms noms;
  final Nom nom;
  final bool basketStatus;
  final String errorMassage;
  final Barcode barcode;
  final String basket;
  final int count;
  final String cellBarcode;
  final String nomBarcode;
  final bool itsMezonine;
  final int time;

  ReturningOutOrderDataState copyWith(
      {ReturningOutOrderDataStatus? status,
      Noms? noms,
      Nom? nom,
      String? errorMassage,
      int? orderStatus,
      Barcode? barcode,
      String? nomBarcode,
      bool? basketStatus,
      String? cellBarcode,
      String? basket,
      int? count,
      bool? itsMezonine,
      int? time}) {
    return ReturningOutOrderDataState(
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
