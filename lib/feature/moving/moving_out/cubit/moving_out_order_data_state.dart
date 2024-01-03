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
      Barcode? barcode,
      this.errorMassage = '',
      this.nomBarcode = '',
      this.itsMezonine = false,
      this.cellBarcode = '',
      this.count = 0})
      : noms = noms ?? Noms.empty,
        barcode = barcode ?? Barcode.empty;

  final MovingOutOrderDataStatus status;
  final Noms noms;
  final String errorMassage;
  final Barcode barcode;
  final double count;
  final String cellBarcode;
  final String nomBarcode;
  final bool itsMezonine;


  MovingOutOrderDataState copyWith(
      {MovingOutOrderDataStatus? status,
      Noms? noms,
      String? errorMassage,
      int? orderStatus,
      Barcode? barcode,
      String? nomBarcode,
      String? cellBarcode,
      double? count,
      bool? itsMezonine}) {
    return MovingOutOrderDataState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        errorMassage: errorMassage ?? this.errorMassage,
        barcode: barcode ?? this.barcode,
        nomBarcode: nomBarcode ?? this.nomBarcode,
        cellBarcode: cellBarcode ?? this.cellBarcode,
        count: count ?? this.count,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage, barcode, count, nomBarcode, itsMezonine, cellBarcode];
}
