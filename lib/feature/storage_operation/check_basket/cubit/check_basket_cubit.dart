import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/storage_operation/check_basket/check_basket_client/check_basket_client.dart';
import 'package:virok_wms/services/printer/connect_printer.dart';
import 'package:virok_wms/services/printer/lables.dart';

import '../check_basket_client/models/basket_info.dart';

part 'check_basket_state.dart';

class CheckBasketCubit extends Cubit<CheckBasketState> {
  CheckBasketCubit() : super(CheckBasketState());

  Future<void> getBaskets() async {
    try {
      final baskets = await CheckBasketApiClient().getBaskets();
      emit(state.copyWith(
          status: CheckBasketStatus.success,
          baskets: baskets,
          filterdBaskets: baskets));
    } catch (e) {
      emit(state.copyWith(
          status: CheckBasketStatus.failure, errorMassage: e.toString()));
    }
  }

  void searchBasket(String value) {
    final searchList = state.baskets.baskets
        .where(
            (basket) => basket.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    emit(state.copyWith(
        status: CheckBasketStatus.success,
        filterdBaskets: BasketsData(baskets: searchList)));
  }

  Future<void> getBasket(String barcode) async {
    try {
      emit(state.copyWith(status: CheckBasketStatus.loading));
      final basket = await CheckBasketApiClient().getBasketInfo(barcode);
      emit(state.copyWith(status: CheckBasketStatus.success, basket: basket));
    } catch (e) {
      emit(state.copyWith(
          status: CheckBasketStatus.failure, errorMassage: e.toString()));
    }
  }

  void changeBusketType() {
    emit(state.copyWith(
        basketType:
            state.basketType.isBasket ? BasketType.cart : BasketType.basket));
  }

  Future<String> addBasket() async {
//    res =  {
//     "ErrorMassage": "OK",
//     "Basket_Name": "Візок 33",
//     "Basket_Barcode": "273411"
// }
    try {
      final res =
          await CheckBasketApiClient().createNewBasket(state.basketType);
      if (res['ErrorMassage'] != "OK") {
        emit(state.copyWith(
            status: CheckBasketStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: res['ErrorMassage']));
        return '';
      }
      await getBaskets();
      return res['Basket_Name'];
    } catch (e) {
      emit(state.copyWith(
          status: CheckBasketStatus.failure, errorMassage: e.toString()));
      rethrow;
    }
  }

  Future<void> printBasket() async {
    final number = state.basket.name.replaceAll(RegExp(r'[^\d]'), "");
    final title = state.basket.name.replaceAll(RegExp(r'[^\W]'), "");
    PrinterConnect().connectToPrinter(
        PrinterLables.basketLable(state.basket.barcode, title, number));
  }

  void clear() {
    emit(state.copyWith(
        status: CheckBasketStatus.initial,
        basket: BasketData.empty,
        errorMassage: ''));
  }

  Future<void> getStateBasketOperations() async {
    final prefs = await SharedPreferences.getInstance();
    final bool basketOperation = prefs.getBool('basketOperation') ?? false;

    emit(state.copyWith(basketOperation: basketOperation));
  }
}
