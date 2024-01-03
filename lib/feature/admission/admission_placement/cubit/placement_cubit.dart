import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_api_client/placement_api_client.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/admission_nom.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/placement_repository.dart';

part 'placement_state.dart';

class PlacementCubit extends Cubit<PlacementState> {
  PlacementCubit() : super(PlacementState());

  Future<void> getNoms() async {
    try {


      await Future.delayed(const Duration(seconds: 2), () {});
      final noms =
          await PlacementRepository().getNoms('Admision_placement_list', '');
      emit(state.copyWith(status: PlacementStatus.success, noms: noms));
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

  void scan(String nomBar, AdmissionNom nom) {
    double count = state.count == 0 ? nom.count : state.count;
    String checkNomBar = '';

    for (var barcode in nom.barcodes) {
      if (barcode.barcode == nomBar) {
        if (count + barcode.ratio > nom.qty) {
          emit(state.copyWith(
              status: PlacementStatus.notFound,
              time: DateTime.now().millisecondsSinceEpoch,
              errorMassage: 'Відсканована більша кількість'));
          checkNomBar = nomBar;
        } else {
          count += barcode.ratio;
          emit(state.copyWith(
              count: count,
              nomBarcode: nomBar,
              status: PlacementStatus.success));
          checkNomBar = nomBar;
          break;
        }
      }
    }
    if (checkNomBar.isEmpty) {
      emit(state.copyWith(status: PlacementStatus.success));
      emit(state.copyWith(
          status: PlacementStatus.notFound, errorMassage: 'Товар не знайдено'));
    }
  }

  void manualCountIncrement(String count, double qty, double nomCount) {
    if ((int.tryParse(count) ?? qty) > qty ||
        (int.tryParse(count) ?? 0) > qty - nomCount) {
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

  Future<void> send(
      String barcode, String cell, String incomingInvoice, double qty) async {
    double count = state.count - qty;
    try {
      final noms = await PlacementRepository().getNoms(
          'Admision_placement_scan', '$barcode $count $incomingInvoice $cell');
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
}
