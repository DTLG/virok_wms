import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/admission/displacement/displacement_client/displacement_api_client.dart';

import '../models/models.dart';

part 'displacement_order_data_state.dart';

class DisplacementOrderDataCubit extends Cubit<DisplacementOrderDataState> {
  DisplacementOrderDataCubit() : super(const DisplacementOrderDataState());

  Future<void> getNoms(DisplacementOrder order) async {
    try {
      final noms = order.invoice == '0'
          ? await DisplacementOrderDataClient()
              .getNoms('StartInvoice', order.docId)
          : await DisplacementOrderDataClient()
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
      final nom = await DisplacementOrderDataClient()
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
      for (var bar in nome.barcodes) {
        if (bar.barcode == barcode) {
          nom = nome;
          break;
        }
      }
    }
    if (nom.name.isEmpty && nom.article.isEmpty) {
      // emit(state.copyWith(
      //     errorMassage: "Товар не знайдено, або штрихкод не належить товару",
      //     time: DateTime.now().millisecondsSinceEpoch,
      //     status: DisplacementOrderDataStatus.notFound));
    }

    return nom;
  }

  Future<void> addNom(String barcode, String invoice, int count) async {
    if (count.toString().length > 6) {
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.notFound,
          errorMassage:
              'Введена завелика кількість - "${count.toStringAsFixed(0)}", максимальна довжина до 6 символів',
          time: DateTime.now().millisecondsSinceEpoch));
      return;
    }
    try {
      final noms = await DisplacementOrderDataClient()
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

      final orders =
          await DisplacementOrderDataClient().getNoms('Close_invoice', invoice);
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.success, noms: orders));
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: DisplacementOrderDataStatus.success));
      }

      emit(state.copyWith(
          status: DisplacementOrderDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  Future<void> closeOrderAndPlace(
    String invoice,
  ) async {
    try {
      final orders = await DisplacementOrderDataClient()
          .getNoms('Close_and_place_invoice ', invoice);
      emit(state.copyWith(
          status: DisplacementOrderDataStatus.success, noms: orders));
    } catch (e) {
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
