part of 'order_data_cubit.dart';

enum ShipmentStatus { initial, loading, success, failure, notFound }

extension ShipmentStatusX on ShipmentStatus {
  bool get isInitial => this == ShipmentStatus.initial;
  bool get isLoading => this == ShipmentStatus.loading;
  bool get isSuccess => this == ShipmentStatus.success;
  bool get isFailure => this == ShipmentStatus.failure;
}

final class ShipmentDataState extends Equatable {
  const ShipmentDataState({this.status = ShipmentStatus.initial, this.noms});

  final ShipmentStatus status;
  final Noms? noms;

  ShipmentDataState copyWith({
    ShipmentStatus? status,
    Noms? noms,
  }) {
    return ShipmentDataState(
        status: status ?? this.status, noms: noms ?? this.noms);
  }

  @override
  List<Object?> get props => [status, noms];
}
