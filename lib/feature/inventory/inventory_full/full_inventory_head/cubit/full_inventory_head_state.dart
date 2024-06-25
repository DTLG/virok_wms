part of 'full_inventory_head_cubit.dart';

enum FullInventoryHeadStatus { initial, loading, success, failure }

extension Inventorystatusx on FullInventoryHeadStatus {
  bool get isInitial => this == FullInventoryHeadStatus.initial;
  bool get isLoading => this == FullInventoryHeadStatus.loading;
  bool get isSuccess => this == FullInventoryHeadStatus.success;
  bool get isFailure => this == FullInventoryHeadStatus.failure;
}

 class FullInventoryHeadState extends Equatable {
   FullInventoryHeadState({
    this.status = FullInventoryHeadStatus.initial,
    Docs? docs,
    this.errorMassage = '',
  }) : docs = docs ?? Docs.empty;

  final FullInventoryHeadStatus status;
  final Docs docs;

  final String errorMassage;

  FullInventoryHeadState copyWith({
    FullInventoryHeadStatus? status,
    Docs? docs,
    String? errorMassage,
  }) {
    return FullInventoryHeadState(
      status: status ?? this.status,
      docs: docs ?? this.docs,
      errorMassage: errorMassage ?? this.errorMassage,
    );
  }

  @override
  List<Object?> get props => [status, errorMassage, docs];
}
