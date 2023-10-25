import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/barcode_lable_print/barcode_lable_print_repo/models/barcodes_noms.dart';
import 'package:virok_wms/feature/placement_writing_off/placement_writeing_off_repository/model/cell_model.dart';
import 'package:virok_wms/feature/placement_writing_off/placement_writeing_off_repository/placement_writeing_off_repository.dart';
part 'placement_goods_state.dart';

class PlacementGoodsCubit extends Cubit<PlacementGoodsState> {
  PlacementGoodsCubit() : super(const PlacementGoodsState());

  Future<int> getCeel(String barcode) async {
    try {
      final cell = await PlacementWritingOffRepo().getCeel(barcode);
      if (cell.cell.first.status == 0) {
        emit(state.copyWith(cellStatus: 1));
        emit(state.copyWith(
            status: PlacementGoodsStatus.notFound, cellStatus: 0));
      } else {
        emit(state.copyWith(
            status: PlacementGoodsStatus.success,
            cell: cell,
            cellBarcode: barcode,
            cellStatus: 1,
            zoneStatus: cell.zone));
      }

      return cell.cell.first.status;
    } catch (e) {
      emit(state.copyWith(
          status: PlacementGoodsStatus.failure, error: e.toString()));
      rethrow;
    }
  }

  Future<void> addNom(String nomBarcode) async {
    double count = state.count;
    final zone = state.cell.zone;
    bool isEqual = false;
    BarcodesNoms noms = BarcodesNoms.empty;
    emit(state.copyWith(
        cellIsEmpty:
            state.cell.cell.first.barcodes.first.isEmpty ? true : false));

    if (state.nom == BarcodesNom.empty) {
      noms = await PlacementWritingOffRepo()
          .getNom('get_from_barcode', nomBarcode);
      emit(state.copyWith(nom: noms.noms.first));
    }

    if (zone == 1) {
      if (state.cellIsEmpty == true) {
        for (var element in state.nom.barodes) {
          if (nomBarcode == element.barcode) {
            isEqual = true;
            count++;
            emit(state.copyWith(
                status: PlacementGoodsStatus.success,
                count: count,
                cellStatus: 1,
                name: state.nom.name,
                article: state.nom.article,
                nomBarcode: nomBarcode));
            break;
          } else {
            isEqual = false;
          }
        }
        if (isEqual == false) {
          emit(state.copyWith(
              status: PlacementGoodsStatus.notFound, cellStatus: 6));
          emit(state.copyWith(cellStatus: 1));
        }
      } else {
        for (var element in state.cell.cell.first.barcodes) {
          if (element == nomBarcode) {
            isEqual = true;
            count++;
            emit(state.copyWith(
                status: PlacementGoodsStatus.success,
                count: count,
                cellStatus: 1,
                nomBarcode: nomBarcode));

            break;
          } else {
            isEqual = false;
          }
        }
        if (isEqual == false) {
          emit(state.copyWith(
              status: PlacementGoodsStatus.notFound, cellStatus: 6));
          emit(state.copyWith(cellStatus: 1));
        }
      }
    } else {
      // zone_2  - - - - - - - - - - - - - - - - - - - -

        for (var element in state.nom.barodes) {
          if (nomBarcode == element.barcode) {
            isEqual = true;
            count++;
            emit(state.copyWith(
                status: PlacementGoodsStatus.success,
                count: count,
                cellStatus: 1,
                name: state.nom.name,
                article: state.nom.article,
                nomBarcode: nomBarcode));
            break;
          } else {
            isEqual = false;
          }
        }
        if (isEqual == false) {
          emit(state.copyWith(
              status: PlacementGoodsStatus.notFound, cellStatus: 6));
          emit(state.copyWith(cellStatus: 1));
        }
     
    }
  }

  

  void manualAddNom(String nomBarcode, String count) {
    emit(state.copyWith(cellStatus: 1));
    emit(state.copyWith(count: double.parse(count)));
  }

  Future<void> sendNom(String ceel, String nom, String count) async {
    try {
      emit(state.copyWith(cellStatus: 1));
      emit(state.copyWith(status: PlacementGoodsStatus.loading));
      final cell = await PlacementWritingOffRepo().sendNom(
        'nom',
        nom,
        count,
        ceel,
      );
      if (cell.cell.first.status == 1 || cell.cell.first.status == 5) {
        emit(state.copyWith(
            status: PlacementGoodsStatus.success,
            cell: cell,
            count: 0,
            nomBarcode: '',
            cellStatus: cell.cell.first.status));
      } else if (cell.cell.first.status == 4) {
        emit(state.copyWith(
            status: PlacementGoodsStatus.notFound,
            cellStatus: 4,
            count: 0,
            nomBarcode: ''));
      }

      Future.delayed(const Duration(seconds: 2), () {
        clear();
        emit(state.copyWith(cellStatus: 1));
      });
    } catch (e) {
      emit(state.copyWith(
          status: PlacementGoodsStatus.failure, error: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(cellStatus: 1));

    emit(state.copyWith(
        status: PlacementGoodsStatus.initial,
        nomBarcode: '',
        cellBarcode: '',
        count: 0,
        cell: Cell.empty,
        nom: BarcodesNom.empty,
        cellIsEmpty: true,
        name: '',
        article: ''));
  }
}
