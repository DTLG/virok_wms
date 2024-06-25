import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/admission/placement/placement_api_client/placement_api_client.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/admission_nom.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/placement_repository.dart';

part 'placement_state.dart';

class PlacementFromReturnCubit
    extends Cubit<PlacementFromRetrunState> {
  PlacementFromReturnCubit()
      : super(PlacementFromRetrunState());


  Future<void> getNoms() async {
    try {
      await Future.delayed(const Duration(seconds: 2), () {});
      final noms = await PlacementRepository().getNoms(
          'Admision_placement_Return_list', '');
      emit(state.copyWith(status: PlacementStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> getNom(String nomNar, String invoice, String taskNumber) async {
    try {
      final nom = await  PlacementRepository().getNom(
          'Admision_placement_by_document_sku', '$nomNar $invoice $taskNumber');

      emit(state.copyWith(status: PlacementStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<int> checkCell(String barcode) async {
    try {
      final cellStatus =
          await PlacementApiClient().checkCell('check_cell', barcode);
      if (cellStatus == 0) {
        emit(state.copyWith(
            status: PlacementStatus.notFound,
            errorMassage: 'Комірку не знайдено',
            time: DateTime.now().millisecondsSinceEpoch));
        return 0;
      } else {
        emit(state.copyWith(cell: barcode, status: PlacementStatus.success));
        return 1;
      }
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
      rethrow;
    }
  }

  bool scan(String nomBar, AdmissionNom nom) {
    double count = state.count == 0 ? nom.count : state.count;

    for (var barcode in nom.barcodes) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(
              status: PlacementStatus.notFound,
              time: DateTime.now().millisecondsSinceEpoch,
              errorMassage: 'Відсканована більша кількість'));
          return false;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              count: count,
              nomBarcode: nomBar,
              status: PlacementStatus.success));
          return true;
        }
      }
    }

    emit(state.copyWith(status: PlacementStatus.success));
    emit(state.copyWith(
        status: PlacementStatus.notFound, errorMassage: 'Товар не знайдено'));
    return false;
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if ((int.tryParse(count) ?? qty) > qty) {
      emit(state.copyWith(status: PlacementStatus.success));
      emit(state.copyWith(
          status: PlacementStatus.notFound,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: 'Введена більша кількість'));
    } else {
      emit(state.copyWith(
          count: double.tryParse(count), status: PlacementStatus.success));
    }
  }

  Future<void> send(String barcode, String cell, String incomingInvoice,
      double qty, String taskNumber) async {
    double count = state.count - qty;
    try {
      final noms = await  PlacementRepository().getNoms(
          'Admision_placement_by_return_scan',
          '$barcode $count $incomingInvoice $taskNumber $cell');
      emit(state.copyWith(status: PlacementStatus.success, noms: noms));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        status: PlacementStatus.success,
        cell: '',
        errorMassage: '',
        count: 0,
        nomBarcode: ''));
  }

  AdmissionNom search(String barcode) {
    AdmissionNom nom = AdmissionNom.empty;
    for (var nome in state.noms.noms) {
      for (var bar in nome.barcodes) {
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
          status: PlacementStatus.notFound));
    }

    return nom;
  }

  Future<void> changeQty(String qty, AdmissionNom nom) async {
    try {
      emit(state.copyWith(status: PlacementStatus.loading));
      final orders = await  PlacementRepository().getNoms(
          'Change_Admision_placement_task', '${nom.taskNumber} $qty');
      emit(state.copyWith(status: PlacementStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> cancelTask(AdmissionNom nom) async {
    try {
      emit(state.copyWith(status: PlacementStatus.loading));
      final orders = await  PlacementRepository().getNoms(
          'Cancel_Admision_placement_task', nom.taskNumber);
      emit(state.copyWith(status: PlacementStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }
}
