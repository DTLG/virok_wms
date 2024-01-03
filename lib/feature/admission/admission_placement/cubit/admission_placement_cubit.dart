import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_api_client/admission_placement_client.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/admission_placement_repository.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/admission_placement_nom.dart';

part 'admission_placement_state.dart';

class AdmissionPlacementCubit extends Cubit<AdmissionPlacementState> {
  AdmissionPlacementCubit() : super(AdmissionPlacementState());



   

  Future<void> getNoms() async {
    try {
      await Future.delayed(const Duration(seconds: 2), () {});
      final noms =
          await AdmissionPlacementRepository().getNoms('Admision_placement_list', '');
      emit(state.copyWith(status: AdmissionPlacementStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: AdmissionPlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> getNom(String nomBarcode, String taskNumber) async {
    try {      await Future.delayed(const Duration(milliseconds: 500),(){});

      final nom = await AdmissionPlacementRepository()
          .getNom('Admision_placement_sku', '$nomBarcode $taskNumber');
      emit(state.copyWith(status: AdmissionPlacementStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: AdmissionPlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<bool> checkCell(String barcode) async {
    try {
      final cellStatus =
          await AdmissionPlacementClient().checkCell('check_cell', barcode);
      if (cellStatus == 0) {
        emit(state.copyWith(
            status: AdmissionPlacementStatus.notFound,
            errorMassage: 'Комірку не знайдено',
            time: DateTime.now().millisecondsSinceEpoch));
        return false;
      } else {
        emit(state.copyWith(cell: barcode, status: AdmissionPlacementStatus.success));
        return true;
      }
    } catch (e) {
      emit(state.copyWith(
          status: AdmissionPlacementStatus.failure, errorMassage: e.toString()));
      rethrow;
    }
  }

  void scan(String nomBar, AdmissionNom nom) {
    double count = state.count == 0 ? nom.count : state.count;
    String checkNomBar = '';

    for (var barcode in nom.barcodes) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(
              status: AdmissionPlacementStatus.notFound,
              time: DateTime.now().millisecondsSinceEpoch,
              errorMassage: 'Відсканована більша кількість'));
          checkNomBar = nomBar;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              count: count,
              nomBarcode: nomBar,
              status: AdmissionPlacementStatus.success));
          checkNomBar = nomBar;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(status: AdmissionPlacementStatus.success));
      emit(state.copyWith(
          status: AdmissionPlacementStatus.notFound, errorMassage: 'Товар не знайдено'));
    }
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if ((int.tryParse(count) ?? qty) > qty
    //  || (int.tryParse(count) ?? 0) > qty - nomCount
        ) {
      emit(state.copyWith(status: AdmissionPlacementStatus.success));
      emit(state.copyWith(
          status: AdmissionPlacementStatus.notFound,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: 'Введена більша кількість'));
    } else {
      emit(state.copyWith(
          count: double.tryParse(count), status: AdmissionPlacementStatus.success));
    }
  }

  Future<void> send(
      String barcode, String cell, String taskNumber, double qty) async {
    double count = state.count - qty;
    try {
      final noms = await AdmissionPlacementRepository().getNoms(
          'Admision_placement_scan', '$barcode $count $taskNumber $cell');
      emit(state.copyWith(status: AdmissionPlacementStatus.success, noms: noms));
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: AdmissionPlacementStatus.failure, errorMassage: e.toString()));
    }
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
          status: AdmissionPlacementStatus.notFound));
    }

    return nom;
  }

    Future<void> changeQty( String count, String taskNumber) async {
    try {
      emit(state.copyWith(status: AdmissionPlacementStatus.loading));
      final orders = await AdmissionPlacementRepository().getNoms(
          'Change_Admision_placement_task',
          '$taskNumber $count');
      emit(state.copyWith(
          status: AdmissionPlacementStatus.success, noms: orders));
      clear();
    } catch (e) {
      emit(state.copyWith(status: AdmissionPlacementStatus.success));

      emit(state.copyWith(
          status: AdmissionPlacementStatus.failure,
          errorMassage: e.toString()));
    }
  }

  clear() {
    emit(state.copyWith(
        status: AdmissionPlacementStatus.success,
        cell: '',
        errorMassage: '',
        count: 0,
        nomBarcode: '',
        nom: AdmissionNom.empty));
  }
}
