import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/recharging/recharge/recharge_repository/models/recharge_noms.dart';
import 'package:virok_wms/feature/recharging/recharge/recharge_repository/recharge_repository.dart';

part 'recharge_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  RechargeCubit() : super(RechargeState());

  Future<void> getNoms() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      final noms = await RechargeRepository().rechargeRepo('recharge_list', '');
      emit(state.copyWith(status: RechargeStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(status: RechargeStatus.failure));
    }
  }

  Future<void> startScan(String taskNumber) async {
    try {
      final noms =
          await RechargeRepository().rechargeRepo('start_recharge', taskNumber);
      emit(state.copyWith(status: RechargeStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(status: RechargeStatus.failure));
    }
  }

  int scanCell(
    String codCell,
    String scanCell,
  ) {
    if (scanCell != codCell) {
      emit(state.copyWith(
          status: RechargeStatus.notFound,
          errorMassage: 'Відскановано не ту комірку',
          time: DateTime.now().millisecondsSinceEpoch));
      return 0;
    } else {
      emit(state.copyWith(cell: scanCell, status: RechargeStatus.success));

      return 1;
    }
  }

  void scanNomWritingOff(String scanBarcode, RechargeNom nom) {
    int count = (state.count == 0 ? nom.countTake : state.count).toInt();
    String checkNomBar = '';
    for (var barcode in nom.barcodes) {
      if (barcode.barcode == scanBarcode) {
        count += barcode.ratio;
        emit(state.copyWith(
            count: count,
            nomBarcode: scanBarcode,
            status: RechargeStatus.success));
        checkNomBar = scanBarcode;
        break;
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(
          status: RechargeStatus.notFound,
          errorMassage: 'Відскановано не той товар',
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void scanNomPlacement(String scanBarcode, RechargeNom nom) {
    int count = (state.count == 0 ? nom.countPut : state.count).toInt();
    String checkNomBar = '';
    for (var barcode in nom.barcodes) {
      if (count + barcode.ratio > nom.countTake) {
        emit(state.copyWith(
            status: RechargeStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: 'Відсканована більша кількість'));
        checkNomBar = scanBarcode;
      } else {
        if (barcode.barcode == scanBarcode) {
          count += barcode.ratio;
          emit(state.copyWith(
              count: count,
              nomBarcode: scanBarcode,
              status: RechargeStatus.success));
          checkNomBar = scanBarcode;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(
          status: RechargeStatus.notFound,
          errorMassage: 'Відскановано не той товар',
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void manualCountIncrement(String count, int type, RechargeNom nom) {
    if (type == 1) {
      emit(state.copyWith(
          count: int.tryParse(count.isEmpty ? '0' : count),
          status: RechargeStatus.success));
    } else {
      if (int.parse(count.isEmpty ? '0' : count) > nom.countTake) {
        emit(state.copyWith(
            status: RechargeStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: 'Введена більша кількість'));
      } else {
        emit(state.copyWith(
            count: int.tryParse(count.isEmpty ? '0' : count),
            status: RechargeStatus.success));
      }
    }
  }

  Future<void> send(int type, String nomBarcode, String cell, String taskNumber,
      RechargeNom nom) async {
    int count = state.count - (type == 1 ? nom.countTake : nom.countPut);
    try {
      final noms = await RechargeRepository().rechargeRepo(
          'recharge_scan', '$type $nomBarcode $count $taskNumber $cell');
      emit(state.copyWith(status: RechargeStatus.success, noms: noms));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: RechargeStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> changeQty(
    int qty,
    RechargeNom nom,
  ) async {
    try {
      final noms = await RechargeRepository().rechargeRepo(
          'change_recharge_task',
          '${nom.barcodes.first.barcode} $qty ${nom.taskNumber}');

      noms.errorMassage == "OK"
          ? emit(state.copyWith(
              status: RechargeStatus.success,
              noms: noms,
            ))
          : emit(state.copyWith(
              status: RechargeStatus.notFound,
              errorMassage: noms.errorMassage,
              noms: noms,
              time: DateTime.now().millisecondsSinceEpoch));

      clear();
    } catch (e) {
      emit(state.copyWith(
          status: RechargeStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        status: RechargeStatus.success,
        errorMassage: '',
        cell: '',
        count: 0,
        nomBarcode: ''));
  }
}
