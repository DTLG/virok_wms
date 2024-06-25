import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/models/noms_model.dart';

import '../barcode_generation_repo/barcode_generation_repo.dart';

part 'barcode_generation_state.dart';

class BarcodeGenerationCubit extends Cubit<BarcodeGenerationState> {
  BarcodeGenerationCubit() : super(BarcodeGenerationState());

  Future<void> getNom(String article) async {
    try {
      if (article.length > 4) {
        if (state.searchValue.isEmpty) {
          emit(state.copyWith(status: BarcodeGenerationStatus.loading));
        }
        final noms =
            await BarcodeGenerationRepo().genBarRepo('get_article', article);
        emit(state.copyWith(
            status: BarcodeGenerationStatus.success,
            noms: noms,
            searchValue: article));
      }
    } catch (e) {
      emit(state.copyWith(
          status: BarcodeGenerationStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> sendBar(String query, String body) async {
    final noms = await BarcodeGenerationRepo().genBarRepo(query, body);
    if (noms.status == 1) {
      emit(state.copyWith(status: BarcodeGenerationStatus.success));
    } else if (noms.status == 2) {
      emit(state.copyWith(
          status: BarcodeGenerationStatus.error,
          errorMassage: 'Штрихкод належить цьому товару'));
    } else if (noms.status == 0) {
      emit(state.copyWith(
          status: BarcodeGenerationStatus.error,
          errorMassage: 'Штрихкод належить іншому товару'));
    }
    await getNom(state.searchValue);
  }

  void clear(){
    emit(state.copyWith(status: BarcodeGenerationStatus.initial, errorMassage: '', searchValue: '', noms: Noms.empty));
  }
}
