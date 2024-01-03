part of 'check_basket_cubit.dart';

enum CheckBasketStatus { initial, loading, success, failure, notFound }

extension CCheckBasketStatusX on CheckBasketStatus {
  bool get isInitial => this == CheckBasketStatus.initial;
  bool get isLoading => this == CheckBasketStatus.loading;
  bool get isSuccess => this == CheckBasketStatus.success;
  bool get isFailure => this == CheckBasketStatus.failure;
  bool get isNotFound => this == CheckBasketStatus.notFound;
}

final class CheckBasketState extends Equatable {
  const CheckBasketState({
    this.status = CheckBasketStatus.initial,
    this.errorMassage = '',
    BasketData? basket,
  }) : basket = basket ?? BasketData.empty;

  final CheckBasketStatus status;
  final BasketData basket;
  final String errorMassage;

  CheckBasketState copyWith(
      {CheckBasketStatus? status, BasketData? basket, String? errorMassage}) {
    return CheckBasketState(
        status: status ?? this.status,
        basket: basket ?? this.basket,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, basket, errorMassage];
}
