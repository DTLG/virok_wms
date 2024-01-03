import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../displacement_repository/displacement_order_data_repository.dart';
import '../displacement_repository/models/noms_model.dart';
import '../displacement_repository/models/order.dart';

part 'displacement_order_data_state.dart';

class DisplacementOrderDataCubit extends Cubit<DisplacementOrderDataState> {
  DisplacementOrderDataCubit() : super(DisplacementOrderDataState());

  Future<void> getNoms(DisplacementOrder order) async {
    try {
      final noms = order.invoice == '0'
          ? await DisplacementOrderDataRepository()
              .getNoms('StartInvoice', order.docId)
          : await DisplacementOrderDataRepository()
              .getNoms('Invoice_data', order.invoice);
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(status: DisplacementOrderDataStatus.success));

      emit(state.copyWith(
          status: DisplacementOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> getNom(String invoice, String barcode) async {
    try {
      final nom = await DisplacementOrderDataRepository()
          .getNom('Invoice_sku_data', '$invoice $barcode');
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  DisplacementNom scan(String barcode) {
    DisplacementNom nom = DisplacementNom.empty;
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
          time: DateTime.now().millisecondsSinceEpoch,
          status: DisplacementOrderDataStatus.notFound));
    }

    return nom;
  }

  Future<void> addNom(String barcode, String invoice, double count) async {
    try {
      final noms = await DisplacementOrderDataRepository()
          .getNoms('Invoice_scan', '$barcode $count $invoice');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(
              errorMassage: noms.errorMassage,
              time: DateTime.now().millisecondsSinceEpoch,
              status: DisplacementOrderDataStatus.notFound))
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

  Future<void> closeOrder(
    String invoice,
  ) async {
    try {
      emit(state.copyWith(status: DisplacementOrderDataStatus.loading));
      await Future.delayed(const Duration(seconds: 1), () {});

      final orders = await DisplacementOrderDataRepository()
          .getNoms('Close_invoice', invoice);
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
        nom: DisplacementNom.empty,
        status: DisplacementOrderDataStatus.success));
  }
}
