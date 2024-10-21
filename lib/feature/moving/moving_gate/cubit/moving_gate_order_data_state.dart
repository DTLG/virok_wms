part of 'moving_gate_order_data_cubit.dart';

enum MovingGateOrderDataStatus { initial, loading, success, failure, notFound }

extension MovingOrderDataStatusX on MovingGateOrderDataStatus {
  bool get isInitial => this == MovingGateOrderDataStatus.initial;
  bool get isLoading => this == MovingGateOrderDataStatus.loading;
  bool get isSuccess => this == MovingGateOrderDataStatus.success;
  bool get isFailure => this == MovingGateOrderDataStatus.failure;
  bool get isNotFound => this == MovingGateOrderDataStatus.notFound;
}

final class MovingGateOrderDataState extends Equatable {
  MovingGateOrderDataState(
      {this.status = MovingGateOrderDataStatus.initial,
      Noms? noms,
      Nom? nom,
      Barcode? barcode,
      this.time = 0,
      this.errorMassage = '',
      this.nomBarcode = '',
      this.cellBarcode = '',
      this.count = 0})
      : noms = noms ?? Noms.empty,
        barcode = barcode ?? Barcode.empty,
        nom = nom ?? Nom.empty;

  final MovingGateOrderDataStatus status;
  final Noms noms;
  final Nom nom;

  final String errorMassage;
  final Barcode barcode;
  final int count;
  final String cellBarcode;
  final String nomBarcode;
  final int time;

  MovingGateOrderDataState copyWith(
      {MovingGateOrderDataStatus? status,
      Noms? noms,
      Nom? nom,
      String? errorMassage,
      int? orderStatus,
      int? time,
      Barcode? barcode,
      String? nomBarcode,
      String? cellBarcode,
      int? count,
      bool? itsMezonine}) {
    return MovingGateOrderDataState(
      status: status ?? this.status,
      noms: noms ?? this.noms,
      nom: nom ?? this.nom,
      time: time ?? this.time,
      errorMassage: errorMassage ?? this.errorMassage,
      barcode: barcode ?? this.barcode,
      nomBarcode: nomBarcode ?? this.nomBarcode,
      cellBarcode: cellBarcode ?? this.cellBarcode,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [
        status,
        noms,
        errorMassage,
        barcode,
        time,
        count,
        nomBarcode,
        cellBarcode,
        nom
      ];
}
