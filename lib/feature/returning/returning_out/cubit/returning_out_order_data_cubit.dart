import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/models/barcode_model.dart';

import 'package:virok_wms/models/noms_model.dart';

import '../returning_out_client/returning_out_api_client.dart';
import '../returning_out_repository/returning_out_order_data_repository.dart';
import 'returning_out_order_head_cubit.dart';

part 'returning_out_order_data_state.dart';

class ReturningOutOrderDataCubit extends Cubit<ReturningOutOrderDataState> {
  ReturningOutOrderDataCubit() : super(ReturningOutOrderDataState());

  Future<void> getNoms(String docId) async {
    try {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.loading));
      await Future.delayed(const Duration(milliseconds: 500),(){});

      final prefs = await SharedPreferences.getInstance();
      final bool itsMezonine = prefs.getBool('its_mezonine') ?? false;
      emit(state.copyWith(itsMezonine: itsMezonine));
      final orders = await ReturningOutOrderDataRepository()
          .movingRepo('get_orders_data', docId);
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.success));

      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
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
          status: ReturningOutOrderDataStatus.notFound,
          errorMassage: 'Дана комірка не відповідає вибраному товару'));
    }
    emit(state.copyWith(status: ReturningOutOrderDataStatus.success));
    res = false;
    return false;
  }

  void scan(String nomBar, Nom nom) {
    double count = state.count == 0? nom.count: state.count;
     String checkNomBar = '';

    for (var barcode in nom.barcode) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(status: ReturningOutOrderDataStatus.success));

          emit(state.copyWith(
              status: ReturningOutOrderDataStatus.notFound,
              errorMassage: 'Відсканована більша кількість'));
checkNomBar = nomBar;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              barcode: barcode,
              count: count,
              nomBarcode: nomBar,
              status: ReturningOutOrderDataStatus.success));
              checkNomBar = nomBar;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.success));
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.notFound,
          errorMassage: 'Товар не знайдено'));
    }
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if ((int.tryParse(count) ?? qty) > qty
    //  ||
    //     (int.tryParse(count) ?? 0) > qty - nomCount
        ) {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.success));
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.notFound,
          errorMassage: 'Введена більша кількість'));
    } else {
      emit(state.copyWith(
          count: double.tryParse(count),
          status: ReturningOutOrderDataStatus.success));
    }
  }

  Future<void> send(String barcode, String docNum, String cell,
      String bascket, double qty) async {
double count = state.count - qty;
    try {
      final orders = await ReturningOutOrderDataRepository().movingRepo(
          'send_selection', '$barcode $count $docNum $cell $bascket');
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> changeQty(String qty, Nom nom, String docId) async {
    try {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.loading));
      final orders = await ReturningOutOrderDataRepository().movingRepo(
          'change_task',
          '${nom.barcode.first.barcode} $qty $docId ${nom.codeCell}');
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.success, noms: orders));
clear();
    } catch (e) {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.success));

      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
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

  Future<void> closeOrder(String docId, MovingOutOrdersHeadCubit cubit) async {
    final fullScanned = checkFullOrder();

    try {
      await ReturningOutOrderDataClient()
          .closeOrder('put_on_tables', '$docId $fullScanned');
      emit(state.copyWith(
        status: ReturningOutOrderDataStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        count: 0,
        nomBarcode: '',
        cellBarcode: '',
        barcode: Barcode(barcode: '', ratio: 1),
        status: ReturningOutOrderDataStatus.success));
  }
}
