import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/return/return_repository/models/noms_model.dart';
import 'package:virok_wms/feature/return/return_repository/models/order.dart';
import 'package:virok_wms/feature/return/return_repository/return_data_repository.dart';

part 'return_data_state.dart';

class ReturnDataCubit extends Cubit<ReturnDataState> {
  ReturnDataCubit() : super(ReturnDataState());

  Future<void> getNoms(ReturnOrder order) async {
    try {
      final orders = order.invoice == '0'
          ? await ReturnDataRepository()
              .getNoms('StartReturnInvoice', order.docId)
          : await ReturnDataRepository()
              .getNoms('Invoice_return_data', order.invoice);
      emit(state.copyWith(status: ReturnDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturnDataStatus.success));

      emit(state.copyWith(
          status: ReturnDataStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> getNom(String invoice, String barcode, String nomStatus) async {
    try {
      final nom = await ReturnDataRepository()
          .getNom('Invoice_return_sku_data', '$invoice $barcode $nomStatus');
      emit(state.copyWith(status: ReturnDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: ReturnDataStatus.failure, errorMassage: e.toString()));
    }
  }

  ReturnNom scan(String barcode) {
    ReturnNom nom = ReturnNom.empty;
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
          status: ReturnDataStatus.notFound));
    }

    return nom;
  }

  Future<void> send(
      String barcode, String invoice, int count, String nomStatus) async {
    try {
      final noms = await ReturnDataRepository().getNoms(
          'Invoice_return_scan', '$barcode $count $invoice $nomStatus');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(
              errorMassage: noms.errorMassage,
              time: DateTime.now().millisecondsSinceEpoch,
              status: ReturnDataStatus.notFound))
          : emit(state.copyWith(status: ReturnDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: ReturnDataStatus.failure, errorMassage: e.toString()));
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
      emit(state.copyWith(status: ReturnDataStatus.loading));

      final orders =
          await ReturnDataRepository().getNoms('Close_invoice', invoice);
      emit(state.copyWith(status: ReturnDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(
          status: ReturnDataStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(
        state.copyWith(nom: ReturnNom.empty, status: ReturnDataStatus.success));
  }
}
