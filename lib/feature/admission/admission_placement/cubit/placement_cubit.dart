import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../placement_repository/model/placement_nom.dart';
import '../placement_repository/placement_repository.dart';


part 'placement_state.dart';

class PlacementCubit extends Cubit<PlacementState> {
  PlacementCubit() : super(PlacementState());
  


  Future<void> getNoms() async {
    try {
      await Future.delayed(const Duration(seconds: 2), () {});
      final noms = await PlacementRepository().getNoms('Placement_list', '');
      emit(state.copyWith(status: PlacementStatus.success, noms: noms));
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> getNom(String nomBarcode) async {
    try {
      final nom =
          await PlacementRepository().getNom('Placement_sku', nomBarcode);
      emit(state.copyWith(status: PlacementStatus.success, nom: nom));
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }



 

  Future<void> createAllAdmisionPlacement() async {
    try {
      emit(state.copyWith(status: PlacementStatus.loading));
      final noms = await PlacementRepository()
          .getNoms('Create_All_Admision_placement', '');
      if (state.noms.errorMassage == "OK") {
        emit(state.copyWith(
            status: PlacementStatus.success,
            noms: noms,
            time: DateTime.now().millisecondsSinceEpoch));
      } else {
        emit(state.copyWith(
            status: PlacementStatus.notFound,
            errorMassage: state.errorMassage,
            time: DateTime.now().millisecondsSinceEpoch));
      }
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> createAdmisionPlacement(String nomBarcode, String count) async {
    try {
      final noms =
          await PlacementRepository().getNoms('Create_Admision_placement', '$nomBarcode $count');
      if (noms.errorMassage == "OK") {
        emit(state.copyWith(
          status: PlacementStatus.success,
          noms: noms,
        ));
      } else {
        emit(state.copyWith(
            status: PlacementStatus.notFound,
            errorMassage: noms.errorMassage,
            time: DateTime.now().millisecondsSinceEpoch));
      }
      clear();
    } catch (e) {
      emit(state.copyWith(
          status: PlacementStatus.failure, errorMassage: e.toString()));
    }
  }

  PlacementNom search(String barcode) {
    PlacementNom nom = PlacementNom.empty;
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

  clear() {
    emit(state.copyWith(
        status: PlacementStatus.success,
        cell: '',
        errorMassage: '',
        count: 0,
        nomBarcode: '',
        nom: PlacementNom.empty));
  }
}
