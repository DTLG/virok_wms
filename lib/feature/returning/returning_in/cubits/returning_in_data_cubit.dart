import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../returning_in_repository/returning_in_data_repository.dart';
import '../returning_in_repository/models/noms_model.dart';
import '../returning_in_repository/models/order.dart';

part 'returning_in_data_state.dart';

class ReturningInDataCubit extends Cubit<ReturningInDataState> {
  ReturningInDataCubit() : super(ReturningInDataState());

  Future<void> getNoms(ReturningInOrder order) async {
    try {      await Future.delayed(const Duration(milliseconds: 500),(){});

      

      final orders = order.invoice == '0'
          ? await ReturningInDataRepository()
              .getNoms('StartInvoice', order.docId)
          : await ReturningInDataRepository()
              .getNoms('Invoice_return_data', order.invoice);
      emit(state.copyWith(
          status: ReturningInDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturningInDataStatus.success));

      emit(state.copyWith(
          status: ReturningInDataStatus.failure,
          errorMassage: e.toString()));
    }
  }


  Future<void> getNom(String invoice, String barcode, String nomStatus) async {
    try {
      final nom = await ReturningInDataRepository()
          .getNom('Invoice_return_sku_data', '$invoice $barcode $nomStatus');
      emit(state.copyWith(
          status: ReturningInDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningInDataStatus.failure,
          errorMassage: e.toString()));
    }
  }


  ReturningInNom scan(String barcode) {
    ReturningInNom nom = ReturningInNom.empty;
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
          status: ReturningInDataStatus.notFound));
    }

    return nom;
  }


    Future<void> send(String barcode, String invoice, double count, String nomStatus) async {
    try {
      final noms = await ReturningInDataRepository()
          .getNoms('Invoice_return_scan', '$barcode $count $invoice $nomStatus');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(
              errorMassage: noms.errorMassage,
              time: DateTime.now().millisecondsSinceEpoch,
              status: ReturningInDataStatus.notFound))
          : emit(state.copyWith(
              status: ReturningInDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningInDataStatus.failure,
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
      emit(state.copyWith(status: ReturningInDataStatus.loading));

      final orders = 
          await ReturningInDataRepository()
              .getNoms('Close_invoice', invoice);
      emit(state.copyWith(
          status: ReturningInDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturningInDataStatus.success));

      emit(state.copyWith(
          status: ReturningInDataStatus.failure,
          errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        nom: ReturningInNom.empty,
        status: ReturningInDataStatus.success));
  }
}
