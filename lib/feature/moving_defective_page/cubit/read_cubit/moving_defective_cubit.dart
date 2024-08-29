import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:virok_wms/feature/moving_defective_page/api_client/api_client.dart';
import 'package:virok_wms/feature/moving_defective_page/model/defective_nom.dart';

part 'moving_defective_state.dart';

class MovingDefectiveCubit extends Cubit<MovingDefectiveState> {
  MovingDefectiveCubit() : super(MovingDefectiveState());

  Future<void> getNoms() async {
    emit(state.copyWith(status: MovingDefectiveStatus.loading));
    final client = ApiClient();
    final List<DefectiveNom>? noms = await client.getNoms('99999999999');
    if (noms == null) {
      emit(state.copyWith(noms: noms, status: MovingDefectiveStatus.error));
    } else {
      emit(state.copyWith(noms: noms, status: MovingDefectiveStatus.loaded));
    }
  }

  Future<void> getMovingData(String doc_number) async {
    emit(state.copyWith(status: MovingDefectiveStatus.loading));
    final client = ApiClient();
    final docs = await client.getMovingData(doc_number);
    emit(state.copyWith(noms: docs, status: MovingDefectiveStatus.loaded));
  }

  void getCell(String doc_number) async {
    final client = ApiClient();
    client.getCell(doc_number);
    emit(state.copyWith(status: MovingDefectiveStatus.success));
  }

  void confirmMoving(String doc_number, String bc_label) async {
    final client = ApiClient();
    bool res = await client.confirmMoving(bc_label, doc_number);
    if (res) {
      emit(state.copyWith(status: MovingDefectiveStatus.success));
    } else {
      emit(state.copyWith(status: MovingDefectiveStatus.error));
    }
  }
}
