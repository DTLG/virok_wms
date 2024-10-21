import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/moving/moving_gate/moving_out_client/moving_out_api_client.dart';
import 'package:virok_wms/models/barcode_model.dart';

import 'package:virok_wms/models/noms_model.dart';

import '../moving_out_repository/moving_out_order_data_repository.dart';
import 'moving_gate_order_head_cubit.dart';

part 'moving_gate_order_data_state.dart';

class NomsPageCubit extends Cubit<MovingGateOrderDataState> {
  NomsPageCubit() : super(MovingGateOrderDataState());

  Future<void> getNoms(String docId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      emit(state.copyWith(status: MovingGateOrderDataStatus.loading));

      final noms = await MovingGateOrderDataRepository()
          .movingRepo('get_moving_out_fromIncoming_data', docId);
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> getNom(
    String docId,
    String nomBarcode,
  ) async {
    try {
      final nom = await MovingGateOrderDataRepository()
          .getNom('get_moving_out_fromIncoming_sku_data', '$docId $nomBarcode');
      emit(state.copyWith(status: MovingGateOrderDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(status: MovingGateOrderDataStatus.success));

      emit(state.copyWith(
          status: MovingGateOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  void scan(String nomBar, Nom nom) {
    int count = state.count == 0 ? nom.count : state.count;
    String checkNomBar = '';

    for (var barcode in nom.barcode) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(
              status: MovingGateOrderDataStatus.notFound,
              errorMassage: 'Відсканована більша кількість',
              time: DateTime.now().millisecondsSinceEpoch));
          checkNomBar = nomBar;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              barcode: barcode,
              count: count,
              nomBarcode: nomBar,
              status: MovingGateOrderDataStatus.success));
          checkNomBar = nomBar;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.notFound,
          errorMassage: 'Товар не знайдено',
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void manualCountIncrement(String count, int qty, int nomCount) {
    if ((int.tryParse(count) ?? qty) > qty
        //  ||
        //     (int.tryParse(count) ?? 0) > qty - nomCount
        ) {
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.notFound,
          errorMassage: 'Введена більша кількість',
          time: DateTime.now().millisecondsSinceEpoch));
    } else {
      emit(state.copyWith(
          count: int.tryParse(count),
          status: MovingGateOrderDataStatus.success));
    }
  }

  Future<void> send(String barcode, String docNum, int qty) async {
    int count = state.count - qty;
    try {
      final orders = await MovingGateOrderDataRepository().movingRepo(
          'send_moving_out_fromIncoming_selection', '$barcode $count $docNum ');
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> changeQty(int qty, Nom nom, String docId) async {
    try {
      emit(state.copyWith(status: MovingGateOrderDataStatus.loading));
      final newQty = qty > nom.qty ? qty - nom.qty : qty;
      final noms = await MovingGateOrderDataRepository().movingRepo(
          qty > nom.qty
              ? 'incrase_moving_out_fromIncoming_count'
              : 'change_moving_out_fromIncoming_count',
          '${nom.barcode.first.barcode} $newQty $docId ');

      noms.status != 7
          ? emit(state.copyWith(
              status: MovingGateOrderDataStatus.success,
              noms: noms,
            ))
          : emit(state.copyWith(
              status: MovingGateOrderDataStatus.notFound,
              errorMassage: 'Товару недостатньо, або товар зарезервований',
              time: DateTime.now().millisecondsSinceEpoch));

      clear();
    } catch (e) {
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.failure,
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

  Future<void> closeOrder(String docId, MovingGateOrdersHeadCubit cubit) async {
    final seconds = Random().nextInt(5) + 2;
    try {
      emit(state.copyWith(status: MovingGateOrderDataStatus.loading));
      await Future.delayed(Duration(seconds: seconds));
      await MovingOutOrderDataClient()
          .closeOrder('close_moving_out_from_incoming', '$docId ');
      // emit(state.copyWith(
      //   status: MovingGateOrderDataStatus.success,
      // ));
    } catch (e) {
      emit(state.copyWith(
          status: MovingGateOrderDataStatus.failure,
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
        status: MovingGateOrderDataStatus.success));
  }

  Nom search(String barcode) {
    Nom nom = Nom.empty;
    for (var nome in state.noms.noms) {
      for (var bar in nome.barcode) {
        if (bar.barcode == barcode) {
          nom = nome;
          break;
        }
      }
    }
    if (nom.name.isEmpty && nom.article.isEmpty) {
      emit(state.copyWith(
          errorMassage: "Товар не знайдено, або штрихкод не належить товару",
          status: MovingGateOrderDataStatus.notFound,
          time: DateTime.now().millisecondsSinceEpoch));
    }

    return nom;
  }
}
