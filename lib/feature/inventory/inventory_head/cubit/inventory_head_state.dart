part of 'inventory_head_cubit.dart';

enum InventoryStatus { initial, loading, success, failure }

extension Inventorystatusx on InventoryStatus {
  bool get isInitial => this == InventoryStatus.initial;
  bool get isLoading => this == InventoryStatus.loading;
  bool get isSuccess => this == InventoryStatus.success;
  bool get isFailure => this == InventoryStatus.failure;
}

final class InventoryHeadState extends Equatable {
   InventoryHeadState({
    this.status = InventoryStatus.initial,
    Docs? docs,
    this.errorMassage = '',
  }) : docs = docs ?? Docs.empty;

  final InventoryStatus status;
  final Docs docs;

  final String errorMassage;

  InventoryHeadState copyWith({
    InventoryStatus? status,
    Docs? docs,
    String? errorMassage,
  }) {
    return InventoryHeadState(
      status: status ?? this.status,
      docs: docs ?? this.docs,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [status, errorMassage, docs];
}
