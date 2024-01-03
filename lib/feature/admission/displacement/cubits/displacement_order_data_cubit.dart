import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../displacement_repository/displacement_order_data_repository.dart';
import '../displacement_repository/models/noms_model.dart';
import '../displacement_repository/models/order.dart';

part 'displacement_order_data_state.dart';

class DisplacementOrderDataCubit extends Cubit<DiplacementOrderDataState> {
  DisplacementOrderDataCubit() : super(DiplacementOrderDataState());

  Future<void> getNoms(DisplacementOrder order) async {
    try {
      emit(state.copyWith(status: DisplacementOrderDataStatus.loading));

      final orders = order.invoice == '0'
          ? await DisplacementOrderDataRepository()
              .displacementRepo('StartInvoice', order.docId)
          : await DisplacementOrderDataRepository()
              .displacementRepo('Invoice_data', order.invoice);
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: DisplacementOrderDataStatus.success));

      emit(state.copyWith(
          status: DisplacementOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> scan(String barcode, String invoice, double count) async {
    try {
      final noms = await DisplacementOrderDataRepository()
          .displacementRepo('Invoice_scan', '$barcode $count $invoice');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(errorMassage: noms.errorMassage,  time: DateTime.now().millisecondsSinceEpoch, status: DisplacementOrderDataStatus.notFound))
          : emit(state.copyWith(
              status: DisplacementOrderDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.failure,
          errorMassage: e.toString()));
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

  Future<void> closeOrder(String invoice,) async {
 try {
      emit(state.copyWith(status: DisplacementOrderDataStatus.loading));

      final orders = 
          await DisplacementOrderDataRepository()
              .displacementRepo('Close_invoice', invoice);
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: DisplacementOrderDataStatus.success));

      emit(state.copyWith(
          status: DisplacementOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        noms: DisplacementNoms.empty,
        status: DisplacementOrderDataStatus.success));
  }
}
