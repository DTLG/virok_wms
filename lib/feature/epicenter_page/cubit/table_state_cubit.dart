import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:virok_wms/feature/epicenter_page/model/nom.dart';
part 'table_state_state.dart';

// Cubit for managing CustomTable state
class CustomTableCubit extends Cubit<CustomTableState> {
  CustomTableCubit(List<Nom> initialNoms)
      : super(CustomTableState(noms: initialNoms));

  // Function to update the noms list
  void updateNoms(List<Nom> updatedNoms) {
    emit(state.copyWith(noms: updatedNoms));
  }

  // Function to update the scroll index (can be triggered externally)
  void scrollToIndex(int index) {
    if (index >= 0 && index < state.noms.length) {
      emit(state.copyWith(scrollIndex: index));
    }
  }

  void updateScrollIndex(int index) {
    emit(state.copyWith(scrollIndex: index));
  }
}
