import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/moving/moving_gate/moving_out_client/moving_out_api_client.dart';
import 'package:virok_wms/models/barcode_model.dart';

import 'package:virok_wms/models/noms_model.dart';

import '../moving_out_repository/moving_gate_order_data_repository.dart';
import 'moving_out_order_head_cubit.dart';

part 'moving_out_order_data_state.dart';

class MovingOutOrderDataCubit extends Cubit<MovingOutOrderDataState> {
  MovingOutOrderDataCubit() : super(MovingOutOrderDataState());

  Future<void> getNoms(String docId) async {
    try {
      final noms = await MovingOutOrderDataRepository()
          .movingRepo('get_orders_data', docId);
      emit(state.copyWith(
        status: MovingOutOrderDataStatus.success,
        noms: noms,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  void writeBasket(String busket) {
    emit(state.copyWith(basket: busket));
  }

  Future<void> getNom(
      String docId, String nomBarcode, String cellBarcode, String taskNumber) async {
    try {
      final nom = await MovingOutOrderDataRepository()
          .getNom('get_order_sku_data', '$docId $nomBarcode $taskNumber $cellBarcode');
      emit(state.copyWith(status: MovingOutOrderDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  bool checkCell(String cellBarcode, List<Cell> cells) {
    emit(state.copyWith(cellBarcode: ''));

    for (var cell in cells) {
      if (cellBarcode == cell.codeCell) {
        emit(state.copyWith(
            cellBarcode: cellBarcode,
            status: MovingOutOrderDataStatus.success));
        return true;
      }
    }
    emit(state.copyWith(
        status: MovingOutOrderDataStatus.notFound,
        errorMassage: 'Дана комірка не відповідає вибраному товару',
        time: DateTime.now().millisecondsSinceEpoch));

    return false;
  }

  void scan(String nomBar, Nom nom) {
    double count = state.count == 0 ? nom.count : state.count;
    String checkNomBar = '';

    for (var barcode in nom.barcode) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(
              status: MovingOutOrderDataStatus.notFound,
              errorMassage: 'Відсканована більша кількість',
              time: DateTime.now().millisecondsSinceEpoch));
          checkNomBar = nomBar;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              barcode: barcode,
              count: count,
              nomBarcode: nomBar,
              status: MovingOutOrderDataStatus.success));
          checkNomBar = nomBar;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.notFound,
          errorMassage: 'Відскановано не той товар',
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if ((int.tryParse(count) ?? qty) > qty) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.notFound,
          errorMassage: 'Введена більша кількість',
          time: DateTime.now().millisecondsSinceEpoch));
    } else {
      emit(state.copyWith(
          count: double.tryParse(count),
          status: MovingOutOrderDataStatus.success));
    }
  }

  Future<void> send(String barcode, String docNum, String cell, String bascket,
      double qty) async {
    double count = state.count - qty;
    try {
      final orders = await MovingOutOrderDataRepository().movingRepo(
          'send_selection', '$barcode $count $docNum $cell $bascket');
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> changeQty(double qty, Nom nom, String docId) async {
    try {
      emit(state.copyWith(status: MovingOutOrderDataStatus.loading));
      final newQty = qty > nom.qty ? qty - nom.qty : qty;
      final noms = await MovingOutOrderDataRepository().movingRepo(
          qty > nom.qty ? 'incrase_moving_out_count' : 'change_task',
          '${nom.barcode.first.barcode} $newQty $docId ${nom.codeCell}');

      noms.status != 7
          ? emit(state.copyWith(
              status: MovingOutOrderDataStatus.success,
              noms: noms,
            ))
          : emit(state.copyWith(
              status: MovingOutOrderDataStatus.notFound,
              errorMassage: 'Товару недостатньо, або товар зарезервований',
              time: DateTime.now().millisecondsSinceEpoch));

      clear();
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.failure,
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
      await MovingOutOrderDataClient()
          .closeOrder('put_on_tables', '$docId $fullScanned');
      emit(state.copyWith(
        status: MovingOutOrderDataStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: MovingOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        count: 0,
        nomBarcode: '',
        cellBarcode: '',
        nom: Nom.empty,
        barcode: Barcode(barcode: '', ratio: 1),
        status: MovingOutOrderDataStatus.success));
  }

  Future<bool> setBasketToOrder(String barcode, String docId) async {
    try {
      String bascketStatus =
          await MovingOutOrderDataClient().setBasketToOrder('$barcode $docId');

      bool res = false;
      if (bascketStatus == '0') {
        emit(state.copyWith(
            status: MovingOutOrderDataStatus.notFound,
            errorMassage: "Кошик зайнятий",
            time: DateTime.now().millisecondsSinceEpoch));
        res = false;
      } else if (bascketStatus == '2') {
        emit(state.copyWith(
            status: MovingOutOrderDataStatus.notFound,
            errorMassage: "Кошик не знайдено",
            time: DateTime.now().millisecondsSinceEpoch));
        res = false;
      } else if (bascketStatus == '1') {
        emit(state.copyWith(basketStatus: true, basket: barcode));
        res = true;
        getNoms(docId);
      }

      return res;
    } catch (e) {
      emit(state.copyWith(status: MovingOutOrderDataStatus.failure));
      rethrow;
    }
  }
}
