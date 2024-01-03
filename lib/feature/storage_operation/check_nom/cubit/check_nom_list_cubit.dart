import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../check_nom_repo/check_nom_repo.dart';
import '../check_nom_repo/models/barcodes_noms.dart';

part 'check_nom_list_state.dart';

class CheckNomListCubit extends Cubit<CheckNomListState> {
  CheckNomListCubit() : super(const CheckNomListState());

  Future<void> getNoms(String query, String value) async {
    try {
      if (value.length >= 4) {
        emit(state.copyWith(
          status: ChecknomStatus.loading
        ));
        final noms = await ChackNomRepository().getNoms(query, value);

        emit(state.copyWith(
          status: ChecknomStatus.success,
          noms: noms,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: ChecknomStatus.failure, errorMassage: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(
        status: ChecknomStatus.initial,
        noms: BarcodesNoms.empty,
        errorMassage: ''));
  }
}
