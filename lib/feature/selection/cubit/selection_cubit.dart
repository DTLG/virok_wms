import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/selection/selection_repository/selection_repository.dart';

import '../../../models/noms_model.dart';

part 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit() : super(SelectionState());

  Future<void> getNoms() async {
    try {
      final noms = await SelectionRepository().selectionRepo('selection', '');
      emit(state.copyWith(status: SelectionStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
        status: SelectionStatus.failure,
      ));
    }
  }

  Future<void> sendNoms(
      String barcode, String count, String container, String cell) async {
    try {
      final noms = await SelectionRepository()
          .selectionRepo('send_selection', '$barcode $count $container $cell');

              noms.status == 0 ||
              noms.status == 2 ||
              noms.status == 6 ||
              noms.status == 3
          ? emit(state.copyWith(status: SelectionStatus.notFound, noms: noms))
          : emit(state.copyWith(
              status: SelectionStatus.success, noms: noms, lastNom: barcode));
    } catch (e) {
      emit(state.copyWith(
        status: SelectionStatus.failure,
      ));
    }
  }

  Future<int> getContainer(String containerBar) async {
    try {
      final noms = await SelectionRepository()
          .selectionRepo('get_container', containerBar);

      noms.status == 3 || noms.status == 5
          ? emit(state.copyWith(status: SelectionStatus.notFound, noms: noms))
          : emit(state.copyWith(
              status: SelectionStatus.success,
              noms: noms,
              containerBar: containerBar));
      return state.noms.status;
    } catch (e) {
      emit(state.copyWith(
        status: SelectionStatus.failure,
      ));
      rethrow;
    }
  }

  Future<void> sendContainer(String container, String lastNom) async {
    try {
      final noms = await SelectionRepository()
          .selectionRepo('full_container', '$container $lastNom');

      noms.status == 4
          ? emit(state.copyWith(status: SelectionStatus.notFound, noms: noms))
          : emit(state.copyWith(
              status: SelectionStatus.success,
              noms: noms,
            ));
    } catch (e) {
      emit(state.copyWith(
        status: SelectionStatus.failure,
      ));
    }
  }

  Future<int> getCell(String cell) async {
    try {
      final noms = await SelectionRepository().selectionRepo('get_cell', cell);

      noms.status == 7
          ? emit(state.copyWith(status: SelectionStatus.notFound, noms: noms))
          : emit(state.copyWith(
              status: SelectionStatus.success, noms: noms, cell: cell));
      return state.noms.status;
    } catch (e) {
      emit(state.copyWith(
        status: SelectionStatus.failure,
      ));
      rethrow;
    }
  }

  void writeCount(String count) {
    emit(state.copyWith(count: count));
  }

  void writeLastNom(String nom) {
    emit(state.copyWith(lastNom: nom));
  }
}
