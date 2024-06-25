part of 'product_lables_cubit.dart';

enum ProductLableStatus { initial, loading, success, failure }

extension ProductLableStatusX on ProductLableStatus {
  bool get isInitial => this == ProductLableStatus.initial;
  bool get isLoading => this == ProductLableStatus.loading;
  bool get isSuccess => this == ProductLableStatus.success;
  bool get isFailure => this == ProductLableStatus.failure;
}

final class ProductLablesState extends Equatable {
  const ProductLablesState(
      {this.status = ProductLableStatus.initial,
      this.errorMassage = '',
      ProductLables? lables,
      ProductLables? filteredLables})
      : lables = lables ?? ProductLables.empty,
        filteredLables = filteredLables ?? ProductLables.empty;

  final ProductLableStatus status;
  final ProductLables lables;
  final ProductLables filteredLables;

  final String errorMassage;

  ProductLablesState copyWith(
      {ProductLables? lables,
      ProductLables? filteredLables,
      ProductLableStatus? status,
      String? errorMassage}) {
    return ProductLablesState(
        status: status ?? this.status,
        lables: lables ?? this.lables,
        filteredLables: filteredLables ?? this.filteredLables,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, lables, errorMassage, filteredLables];
}
