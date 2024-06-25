import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/returning/returning_out/returning_out_client/returning_out_api_client.dart';
import 'package:virok_wms/models/barcode_model.dart';

import 'package:virok_wms/models/noms_model.dart';

import '../returning_out_repository/returning_out_order_data_repository.dart';
import 'returning_out_order_head_cubit.dart';

part 'returning_out_order_data_state.dart';

class ReturningOutOrderDataCubit extends Cubit<ReturningOutOrderDataState> {
  ReturningOutOrderDataCubit() : super(ReturningOutOrderDataState());

    Future<void> getNoms(String docId) async {
    try {
      final orders = await ReturningOutOrderDataRepository()
          .getNoms('get_orders_data', docId);
      emit(state.copyWith(
        status: ReturningOutOrderDataStatus.success,
        noms: orders,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  void writeBasket(String busket) {
    emit(state.copyWith(basket: busket));
  }

  Future<void> getNom(String docId, String nomBarcode, String cellBarcode,
      String taskNumber) async {
    try {
      final nom = await ReturningOutOrderDataRepository().getNom(
          'get_order_sku_data', '$docId $nomBarcode $taskNumber $cellBarcode');
      emit(state.copyWith(status: ReturningOutOrderDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  bool checkCell(String cellBarcode, List<Cell> cells) {
    emit(state.copyWith(
        cellBarcode: '', status: ReturningOutOrderDataStatus.success));

    for (var cell in cells) {
      if (cellBarcode == cell.codeCell) {
        emit(state.copyWith(
            cellBarcode: cellBarcode,
            status: ReturningOutOrderDataStatus.success));
        return true;
      }
    }
    emit(state.copyWith(
        status: ReturningOutOrderDataStatus.notFound,
        errorMassage: 'Дана комірка не відповідає вибраному товару',
        time: DateTime.now().millisecondsSinceEpoch));

    return false;
  }

  bool scan(String nomBar, Nom nom) {
    double count = state.count == 0 ? nom.count : state.count;

    for (var barcode in nom.barcode) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(
              status: ReturningOutOrderDataStatus.notFound,
              errorMassage: 'Відсканована більша кількість',
              time: DateTime.now().millisecondsSinceEpoch));
          return false;
        }

        count += barcode.ratio;
        emit(state.copyWith(
            barcode: barcode,
            count: count,
            nomBarcode: nomBar,
            status: ReturningOutOrderDataStatus.success));

        return true;
      }
    }
    emit(state.copyWith(
        status: ReturningOutOrderDataStatus.notFound,
        errorMassage: 'Відскановано не той товар',
        time: DateTime.now().millisecondsSinceEpoch));
    return false;
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if (count.length > 6) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.notFound,
          errorMassage:
              'Введена завелика кількість - "$count", максимальна довжина до 6 символів',
          time: DateTime.now().millisecondsSinceEpoch));
      return;
    }
    final formatingCount = int.tryParse(count);

    if ((formatingCount ?? qty) > qty) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.notFound,
          errorMassage: 'Введена більша кількість',
          time: DateTime.now().millisecondsSinceEpoch));
    } else {
      emit(state.copyWith(
          count: double.tryParse(count),
          status: ReturningOutOrderDataStatus.success));
    }
  }

  Future<void> send(String barcode, String docNum, String cell, String bascket,
      double qty, String taskNumber) async {
    double count = state.count - qty;
    try {
      final orders = await ReturningOutOrderDataRepository().getNoms(
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
      final orders = await ReturningOutOrderDataRepository().getNoms(
          'change_task',
          '${nom.barcode.first.barcode} $qty $docId ${nom.codeCell}');
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: ReturningOutOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  int checkFullOrder() {
    final noms = state.noms;

    for (var nom in noms.noms) {
      if (nom.count < nom.qty) {
        return 0;
      }
    }
    return 1;
  }

  Future<void> closeOrder(String docId, ReturningOutOrdersHeadCubit cubit) async {
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
        nom: Nom.empty,
        barcode: Barcode(barcode: '', ratio: 1),
        status: ReturningOutOrderDataStatus.success));
  }

  Future<bool> setBasketToOrder(String barcode, String docId) async {
    try {
      String bascketStatus =
          await ReturningOutOrderDataClient().setBasketToOrder('$barcode $docId');

      bool res = false;
      if (bascketStatus == '0') {
        emit(state.copyWith(
            status: ReturningOutOrderDataStatus.notFound,
            errorMassage: "Кошик зайнятий",
            time: DateTime.now().millisecondsSinceEpoch));
        res = false;
      } else if (bascketStatus == '2') {
        emit(state.copyWith(
            status: ReturningOutOrderDataStatus.notFound,
            errorMassage: "Кошик не знайдено",
            time: DateTime.now().millisecondsSinceEpoch));
        res = false;
      } else if (bascketStatus == '1') {
        emit(state.copyWith(
            basketStatus: true,
            basket: barcode,
            status: ReturningOutOrderDataStatus.success));
        res = true;
        getNoms(docId);
      }

      return res;
    } catch (e) {
      emit(state.copyWith(status: ReturningOutOrderDataStatus.failure));
      rethrow;
    }
  }}