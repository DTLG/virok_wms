part of 'check_basket_cubit.dart';

enum CheckBasketStatus { initial, loading, success, failure, notFound }

extension CCheckBasketStatusX on CheckBasketStatus {
  bool get isInitial => this == CheckBasketStatus.initial;
  bool get isLoading => this == CheckBasketStatus.loading;
  bool get isSuccess => this == CheckBasketStatus.success;
  bool get isFailure => this == CheckBasketStatus.failure;
  bool get isNotFound => this == CheckBasketStatus.notFound;
}

extension BaskettypeX on BasketType {
  bool get isBasket => this == BasketType.basket;
  bool get isCart => this == BasketType.cart;
}

final class CheckBasketState extends Equatable {
  CheckBasketState(
      {this.status = CheckBasketStatus.initial,
      this.errorMassage = '',
      this.time = 0,
      BasketData? basket,
      BasketsData? baskets,
      BasketsData? filterdBaskets,
      this.basketType = BasketType.basket,
      this.basketOperation = false})
      : basket = basket ?? BasketData.empty,
        baskets = baskets ?? BasketsData.empty,
        filterdBaskets = filterdBaskets ?? BasketsData.empty;

  final CheckBasketStatus status;
  final BasketData basket;
  final String errorMassage;
  final BasketsData baskets;
  final BasketsData filterdBaskets;
  final BasketType basketType;
  final int time;
  final bool basketOperation;

  CheckBasketState copyWith(
      {CheckBasketStatus? status,
      BasketData? basket,
      String? errorMassage,
      BasketsData? filterdBaskets,
      BasketType? basketType,
      BasketsData? baskets,
      int? time,
      bool? basketOperation}) {
    return CheckBasketState(
        status: status ?? this.status,
        basket: basket ?? this.basket,
        baskets: baskets ?? this.baskets,
        filterdBaskets: filterdBaskets ?? this.filterdBaskets,
        basketType: basketType ?? this.basketType,
        errorMassage: errorMassage ?? this.errorMassage,
        time: time ?? this.time,
        basketOperation: basketOperation ?? this.basketOperation);
  }

  @override
  List<Object?> get props => [
        status,
        basket,
        baskets,
        filterdBaskets,
        errorMassage,
        basketType,
        time,
        basketOperation
      ];
}
