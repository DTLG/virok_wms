import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:virok_wms/feature/moving_defective_page/api_client/api_client.dart';
import 'package:virok_wms/feature/moving_defective_page/model/defective_nom.dart';

import '../../widget/toast.dart';

part 'create_defective_order_page_state.dart';

class CreateDefectiveOrderPageCubit
    extends Cubit<CreateDefectiveOrderPageState> {
  CreateDefectiveOrderPageCubit() : super(CreateDefectiveOrderPageState());

  Future<void> getCell(String barcode) async {
    emit(state.copyWith(status: CreateDefectiveOrderPageStatus.loading));
    final client = ApiClient();
    final List<DefectiveNom>? noms = await client.getCell(barcode);
    if (noms == null) {
      emit(state.copyWith(
          noms: noms, status: CreateDefectiveOrderPageStatus.error));
    } else {
      emit(state.copyWith(
          noms: noms, status: CreateDefectiveOrderPageStatus.loaded));
    }
  }

  Future<void> setNoms(String barcode) async {
    emit(state.copyWith(status: CreateDefectiveOrderPageStatus.loading));
    final client = ApiClient();
    final List<DefectiveNom>? noms = await client.setNoms(barcode);
    if (noms == null) {
      showToast("Виникла помилка");
      emit(state.copyWith(
          noms: noms, status: CreateDefectiveOrderPageStatus.error));
    } else {
      showToast("Дані успішно додано");
      emit(state.copyWith(
          noms: noms, status: CreateDefectiveOrderPageStatus.loaded));
    }
  }
}
