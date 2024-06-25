import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../moving_in_repository/moving_in_data_repository.dart';
import '../moving_in_repository/models/noms_model.dart';
import '../moving_in_repository/models/order.dart';

part 'moving_in_data_state.dart';

class MovingInDataCubit extends Cubit<MovingInDataState> {
  MovingInDataCubit() : super(MovingInDataState());

  Future<void> getNoms(MovingInOrder order) async {
    try {
      emit(state.copyWith(status: MovingInDataStatus.loading));

      final orders = order.invoice == '0'
          ? await MovingInDataRepository()
              .movingInRepo('StartInvoice', order.docId)
          : await MovingInDataRepository()
              .movingInRepo('Invoice_data', order.invoice);
      emit(state.copyWith(status: MovingInDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: MovingInDataStatus.success));

      emit(state.copyWith(
          status: MovingInDataStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> scan(String barcode, String invoice, double count) async {
    if (count.toString().length > 6) {
      emit(state.copyWith(
          errorMassage:
              'Введена завелика кількість - "${count.toStringAsFixed(0)}", максимальна довжина до 6 символів',
          time: DateTime.now().millisecondsSinceEpoch,
          status: MovingInDataStatus.notFound));
      return;
    }
    try {
      final noms = await MovingInDataRepository()
          .movingInRepo('Invoice_scan', '$barcode $count $invoice');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(
              errorMassage: noms.errorMassage,
              time: DateTime.now().millisecondsSinceEpoch,
              status: MovingInDataStatus.notFound))
          : emit(
              state.copyWith(status: MovingInDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: MovingInDataStatus.failure, errorMassage: e.toString()));
    }
  }

  int checkFullOrder() {
    final noms = state.noms;
    int res = 0;

    for (var nom in noms.noms) {
      if (nom.count == 0) {
        res = 0;
      } else {
        res = 1;
        return 1;
      }
    }

    return res;
  }

  Future<void> closeOrder(
    String invoice,
  ) async {
    try {
      emit(state.copyWith(status: MovingInDataStatus.loading));

      final orders =
          await MovingInDataRepository().movingInRepo('Close_invoice', invoice);
      emit(state.copyWith(status: MovingInDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: MovingInDataStatus.success));

      emit(state.copyWith(
          status: MovingInDataStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(status: MovingInDataStatus.success));
  }

  MovingInNom search(String barcode) {
    MovingInNom nom = MovingInNom.empty;

    for (var nome in state.noms.noms) {
      for (var bar in nome.barcodes) {
        if (bar.barcode == barcode) {
          nom = nome;
          break;
        }
      }
    }

    // emit(state.copyWith(
    //     errorMassage: "Товар не знайдено, або штрихкод не належить товару",
    //     time: DateTime.now().millisecondsSinceEpoch,
    //     status: MovingInDataStatus.notFound));

    return nom;
  }
}
