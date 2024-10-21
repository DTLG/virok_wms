part of 'moving_out_order_data_cubit.dart';

enum MovingOutOrderDataStatus { initial, loading, success, failure, notFound }

extension MovingOrderDataStatusX on MovingOutOrderDataStatus {
  bool get isInitial => this == MovingOutOrderDataStatus.initial;
  bool get isLoading => this == MovingOutOrderDataStatus.loading;
  bool get isSuccess => this == MovingOutOrderDataStatus.success;
  bool get isFailure => this == MovingOutOrderDataStatus.failure;
  bool get isNotFound => this == MovingOutOrderDataStatus.notFound;
}

final class MovingOutOrderDataState extends Equatable {
  MovingOutOrderDataState(
      {this.status = MovingOutOrderDataStatus.initial,
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

  final MovingOutOrderDataStatus status;
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

  MovingOutOrderDataState copyWith(
      {MovingOutOrderDataStatus? status,
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
    return MovingOutOrderDataState(
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
