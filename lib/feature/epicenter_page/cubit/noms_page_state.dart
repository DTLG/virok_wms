part of 'noms_page_cubit.dart';

enum EpicenterDataStatus { initial, loading, success, failure, notFound }

extension EpicenterDataStatusX on EpicenterDataStatus {
  bool get isInitial => this == EpicenterDataStatus.initial;
  bool get isLoading => this == EpicenterDataStatus.loading;
  bool get isSuccess => this == EpicenterDataStatus.success;
  bool get isFailure => this == EpicenterDataStatus.failure;
  bool get isNotFound => this == EpicenterDataStatus.notFound;
}

final class EpicenterDataState extends Equatable {
  EpicenterDataState(
      {this.status = EpicenterDataStatus.initial,
      this.noms = const [],
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
      : barcode = barcode ?? Barcode.empty,
        nom = nom ?? Nom.empty;

  final EpicenterDataStatus status;
  final List<Nom> noms;
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

  EpicenterDataState copyWith(
      {EpicenterDataStatus? status,
      List<Nom>? noms,
      Nom? nom,
      String? errorMassage,
      int? orderStatus,
      Barcode? barcode,
      String? nomBarcode,
      bool? basketStatus,
      String? cellBarcode,
      String? basket,
      double? count,
      bool? itsMezonine,
      int? time}) {
    return EpicenterDataState(
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
