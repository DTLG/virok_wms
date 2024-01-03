import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../check_basket_repository/check_basket_repository.dart';
import '../check_basket_repository/models/basket_info.dart';


part 'check_basket_state.dart';

class CheckBasketCubit extends Cubit<CheckBasketState> {
  CheckBasketCubit() : super(const CheckBasketState());

  Future<void> getBasket(String barcode) async {
    try {
      emit(state.copyWith(status: CheckBasketStatus.loading));
      final basket = await CheckBasketRepository().getBasketInfo(barcode);
      emit(state.copyWith(status: CheckBasketStatus.success, basket: basket));
    } catch (e) {
      emit(state.copyWith(
          status: CheckBasketStatus.failure, errorMassage: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(
        status: CheckBasketStatus.initial,
        basket: BasketData.empty,
        errorMassage: ''));
  }
}
