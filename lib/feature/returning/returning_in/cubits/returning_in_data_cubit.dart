import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../returning_in_repository/returning_in_data_repository.dart';
import '../returning_in_repository/models/noms_model.dart';
import '../returning_in_repository/models/order.dart';

part 'returning_in_data_state.dart';

class ReturningInDataCubit extends Cubit<ReturningInDataState> {
  ReturningInDataCubit() : super(ReturningInDataState());

  Future<void> getNoms(ReturningInOrder order) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      emit(state.copyWith(status: ReturningInDataStatus.loading));

      final orders = order.invoice == '0'
          ? await ReturningInDataRepository()
              .getNoms('StartInvoice', order.docId)
          : await ReturningInDataRepository()
              .getNoms('Invoice_data', order.invoice);
      emit(state.copyWith(status: ReturningInDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturningInDataStatus.success));

      emit(state.copyWith(
          status: ReturningInDataStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> getNom(String invoice, String barcode) async {
    try {
      final nom = await ReturningInDataRepository()
          .getNom('Invoice_sku_data', '$invoice $barcode');
      emit(state.copyWith(status: ReturningInDataStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningInDataStatus.failure, errorMassage: e.toString()));
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

  //   void scan1(String nomBar, ReturningInNom nom) {
  //   int count = state.count == 0 ? nom.count : state.count;
  //   String checkNomBar = '';

  //   for (var barcode in nom.barcode) {
  //     if (barcode.barcode == nomBar) {
  //       if (count + barcode.ratio > nom.qty) {
  //         emit(state.copyWith(
  //             status: ReturningInDataStatus.notFound,
  //             errorMassage: 'Відсканована більша кількість',
  //             time: DateTime.now().millisecondsSinceEpoch));
  //         checkNomBar = nomBar;
  //       } else {
  //         count += barcode.ratio;
  //         emit(state.copyWith(
  //             count: count,
  //             nomBarcode: nomBar,
  //             status: ReturningInDataStatus.success));
  //         checkNomBar = nomBar;
  //         break;
  //       }
  //     }
  //   }
  //   if (checkNomBar.isEmpty) {
  //     emit(state.copyWith(
  //         status: ReturningInDataStatus.notFound,
  //         errorMassage: 'Товар не знайдено',
  //         time: DateTime.now().millisecondsSinceEpoch));
  //   }
  // }

  Future<void> addNom(String barcode, String invoice, int count) async {
    try {
      final noms = await ReturningInDataRepository()
          .getNoms('Invoice_scan', '$barcode $count $invoice');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(
              errorMassage: noms.errorMassage,
              time: DateTime.now().millisecondsSinceEpoch,
              status: ReturningInDataStatus.notFound))
          : emit(state.copyWith(
              status: ReturningInDataStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningInDataStatus.failure, errorMassage: e.toString()));
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
      emit(state.copyWith(status: ReturningInDataStatus.loading));

      final orders =
          await ReturningInDataRepository().getNoms('Close_invoice', invoice);
      emit(state.copyWith(status: ReturningInDataStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturningInDataStatus.success));

      emit(state.copyWith(
          status: ReturningInDataStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        nom: ReturningInNom.empty, status: ReturningInDataStatus.success));
  }
}
