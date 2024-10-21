import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/returning/return_epic/model/return_epic_nom.dart';

import '../return_epic_client/return_epic_client.dart';

part 'return_epic_state.dart';

class ReturnEpicCubit extends Cubit<ReturnEpicState> {
  ReturnEpicCubit() : super(const ReturnEpicState());

  Future<void> getNoms() async {
    try {
      final noms =
          await ReturnEpicClient().getNoms('get_return_in_epicentr_list', '');
      emit(state.copyWith(status: ReturningEpicStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(status: ReturningEpicStatus.success));

      emit(state.copyWith(
          status: ReturningEpicStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> getNom(
      String invoice, String barcode, String status, String number) async {
    try {
      final nom = await ReturnEpicClient().getNom(
          'Invoice_return_epicentr_sku_data',
          '$invoice $barcode $status $number');
      emit(state.copyWith(status: ReturningEpicStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningEpicStatus.failure, errorMassage: e.toString()));
    }
  }

  ReturnEpicNom search(String barcode) {
    ReturnEpicNom nom = ReturnEpicNom.empty;
    for (var nome in state.noms.noms) {
      for (var bar in nome.barcodes) {
        if (bar.barcode == barcode) {
          nom = nome;
          break;
        }
      }
    }
    if (nom == ReturnEpicNom.empty) {
      emit(state.copyWith(
          errorMassage: "Товар не знайдено, або штрихкод не належить товару",
          time: DateTime.now().millisecondsSinceEpoch,
          status: ReturningEpicStatus.notFound));
    }

    return nom;
  }

  Future<void> scan(
      String barcode, ReturnEpicNom nom, int count, String nomStatus) async {
    if (count.toString().length > 6) {
      emit(state.copyWith(
          status: ReturningEpicStatus.notFound,
          errorMassage:
              'Введена завелика кількість - "${count.toStringAsFixed(0)}", максимальна довжина до 6 символів',
          time: DateTime.now().millisecondsSinceEpoch));
      return;
    }
    try {
      final noms = await ReturnEpicClient().getNoms(
          'Invoice_return_epicentr_scan',
          '$barcode $count ${nom.incomingInvoiceNumber} $nomStatus ${nom.number}');
      noms.errorMassage != "OK"
          ? emit(state.copyWith(
              errorMassage: noms.errorMassage,
              time: DateTime.now().millisecondsSinceEpoch,
              status: ReturningEpicStatus.notFound))
          : emit(
              state.copyWith(status: ReturningEpicStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: ReturningEpicStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> closeOrder() async {
    try {
      emit(state.copyWith(status: ReturningEpicStatus.loading));

      final orders =
          await ReturnEpicClient().getNoms('Close_return_epicentr', '');
      emit(state.copyWith(status: ReturningEpicStatus.success, noms: orders));
    } catch (e) {
      emit(state.copyWith(status: ReturningEpicStatus.success));

      emit(state.copyWith(
          status: ReturningEpicStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        nom: ReturnEpicNom.empty, status: ReturningEpicStatus.success));
  }
}
