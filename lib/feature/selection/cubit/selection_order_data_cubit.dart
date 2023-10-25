import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/selection/selection_client/selection_api_client.dart';
import 'package:virok_wms/feature/selection/selection_repository/selection_order_data_repository.dart';
import 'package:virok_wms/models/noms_model.dart';

part 'selection_order_data_state.dart';

class SelectionOrderDataCubit extends Cubit<SelectionOrderDataState> {
  SelectionOrderDataCubit() : super(SelectionOrderDataState());

  Future<void> getNoms(String docId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool itsMezonine = prefs.getBool('its_mezonine') ?? false;
      emit(state.copyWith(itsMezonine: itsMezonine));
      final String body = itsMezonine == true ? docId : '';
      emit(state.copyWith(status: SelectionOrderDataStatus.loading));
      final orders = await SelectionOrderDataRepository()
          .selectionRepo('get_orders_data', body);
      emit(state.copyWith(status: SelectionOrderDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));

      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure, errorMassage: e.toString()));
    }
  }

  void scan(String nomBar, Nom nom) {
    int count = state.count;

    for (var barcode in nom.barcode) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(status: SelectionOrderDataStatus.success));

          emit(state.copyWith(
              status: SelectionOrderDataStatus.notFound,
              errorMassage: 'Відсканована більша кількість'));
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              barcode: barcode,
              count: count,
              nomBarcode: nomBar,
              status: SelectionOrderDataStatus.success));
          break;
        }
      }
    }
    if (state.nomBarcode.isEmpty) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));
      emit(state.copyWith(
          status: SelectionOrderDataStatus.notFound, errorMassage: 'Товар не знайдено'));
    }
  }

  void manualCountIncrement(String count, double qty) {
    if ((int.tryParse(count) ?? qty) > qty) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));
      emit(state.copyWith(
          status: SelectionOrderDataStatus.notFound,
          errorMassage: 'Введена більша кількість'));
    } else {
      emit(state.copyWith(
          count: int.tryParse(count), status: SelectionOrderDataStatus.success));
    }
  }

  Future<void> send(String barcode, int count, String docNum, String cell,
      String bascket) async {
    try {
      final orders = await SelectionOrderDataRepository().selectionRepo(
          'send_selection', '$barcode $count $docNum $cell $bascket');
      emit(state.copyWith(status: SelectionOrderDataStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> closeOrder() async {
    try {
      if (state.itsMezonine == true) {
        await SelectionOrderDataClient().closeOrderM();
        emit(state.copyWith(
          status: SelectionOrderDataStatus.success,
        ));
      } else {
        final orders = await SelectionOrderDataRepository()
            .selectionRepo('put_on_tables', '');

        emit(state.copyWith(status: SelectionOrderDataStatus.success, noms: orders));
      }
    } catch (e) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        count: 0,
        nomBarcode: '',
        barcode: Barcode(barcode: '', ratio: 1),
        status: SelectionOrderDataStatus.success));
  }
}
