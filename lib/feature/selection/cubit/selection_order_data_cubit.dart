import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/selection/cubit/selection_order_head_cubit.dart';
import 'package:virok_wms/feature/selection/selection_repository/selection_order_data_repository.dart';
import 'package:virok_wms/models/noms_model.dart';

import '../../../models/barcode_model.dart';
import '../selection_client/selection_api_client.dart';

part 'selection_order_data_state.dart';

class SelectionOrderDataCubit extends Cubit<SelectionOrderDataState> {
  SelectionOrderDataCubit() : super(SelectionOrderDataState());

  Future<void> getNoms(String docId) async {
    try {
      emit(state.copyWith(status: SelectionOrderDataStatus.loading));

      final prefs = await SharedPreferences.getInstance();
      final bool itsMezonine = prefs.getBool('its_mezonine') ?? false;
      emit(state.copyWith(itsMezonine: itsMezonine));
      final orders = await SelectionOrderDataRepository()
          .selectionRepo('get_orders_data', docId);
      emit(state.copyWith(
          status: SelectionOrderDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));

      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  bool checkCell(String cellBarcode, List<Cell> cells) {
    bool res = false;
    emit(state.copyWith(cellBarcode: ''));

    for (var cell in cells) {
      if (cellBarcode == cell.codeCell) {
        emit(state.copyWith(cellBarcode: cellBarcode));
        res = true;
        return res;
      }
    }
    if (state.cellBarcode.isEmpty) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.notFound,
          errorMassage: 'Дана комірка не відповідає вибраному товару'));
    }
    emit(state.copyWith(status: SelectionOrderDataStatus.success));
    res = false;
    return false;
  }

  void scan(String nomBar, Nom nom) {
    double count = state.count == 0? nom.count: state.count;
     String checkNomBar = '';

    for (var barcode in nom.barcode) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(status: SelectionOrderDataStatus.success));

          emit(state.copyWith(
              status: SelectionOrderDataStatus.notFound,
              errorMassage: 'Відсканована більша кількість'));
checkNomBar = nomBar;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              barcode: barcode,
              count: count,
              nomBarcode: nomBar,
              status: SelectionOrderDataStatus.success));
              checkNomBar = nomBar;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));
      emit(state.copyWith(
          status: SelectionOrderDataStatus.notFound,
          errorMassage: 'Товар не знайдено'));
    }
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if ((int.tryParse(count) ?? qty) > qty ) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));
      emit(state.copyWith(
          status: SelectionOrderDataStatus.notFound,
          errorMassage: 'Введена більша кількість'));
    } else {
      emit(state.copyWith(
          count: double.tryParse(count),
          status: SelectionOrderDataStatus.success));
    }
  }

  Future<void> send(String barcode, String docNum, String cell,
      String bascket, double qty) async {
double count = state.count - qty;
    try {
      final orders = await SelectionOrderDataRepository().selectionRepo(
          'send_selection', '$barcode $count $docNum $cell $bascket');
      emit(state.copyWith(
          status: SelectionOrderDataStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> changeQty(String qty, Nom nom, String docId) async {
    try {
      emit(state.copyWith(status: SelectionOrderDataStatus.loading));
      final orders = await SelectionOrderDataRepository().selectionRepo(
          'change_task',
          '${nom.barcode.first.barcode} $qty $docId ${nom.codeCell}');
      emit(state.copyWith(
          status: SelectionOrderDataStatus.success, noms: orders));
clear();
    } catch (e) {
      emit(state.copyWith(status: SelectionOrderDataStatus.success));

      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  int checkFullOrder() {
    final noms = state.noms;
    int res = 0;

    for (var nom in noms.noms) {
      if (nom.count < nom.qty) {
        res = 0;
        return 0;
      } else {
        res = 1;
      }
    }

    return res;
  }

  Future<void> closeOrder(String docId, SelectionOrdersHeadCubit cubit) async {
    final fullScanned = checkFullOrder();

    try {
      await SelectionOrderDataClient()
          .closeOrder('put_on_tables', '$docId $fullScanned');
      emit(state.copyWith(
        status: SelectionOrderDataStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: SelectionOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        count: 0,
        nomBarcode: '',
        cellBarcode: '',
        barcode: Barcode(barcode: '', ratio: 1),
        status: SelectionOrderDataStatus.success));
  }
}
