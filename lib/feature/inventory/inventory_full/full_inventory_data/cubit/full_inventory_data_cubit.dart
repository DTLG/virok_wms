import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_full/full_inventory_data_repository/full_inventory_repository.dart';
import 'package:virok_wms/feature/inventory/inventory_full/models/inventory.dart';


part 'full_inventory_data_state.dart';

class FullInventoryDataCubit extends Cubit<FullInventoryDataState> {
  FullInventoryDataCubit() : super(FullInventoryDataState());

  Future<void> getNomByBarcode(String barcode, String docNumber) async {
    try {
      final nom = await FullInventoryRepository().getNomData(
          'Full_Inventory_sku_all_status_data', '$barcode $docNumber');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: FullInventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: FullInventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
    }
  }
    Future<void> getNomByArticle(String barcode, String docNumber) async {
    try {
      final nom = await FullInventoryRepository().getNomData(
          'Full_Inventory_sku_all_status_by_article_data', '$barcode $docNumber');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: FullInventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: FullInventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
    }
  }


  Future<void> getSelectNom(
      String barcode, String docNumber, String nomStatus) async {
    try {
      final nom = await FullInventoryRepository().getNomData(
          'Full_Inventory_sku_data', '$barcode $docNumber $nomStatus');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(selectNom: nom, status: FullInventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: FullInventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
    }
  }

  bool scanCell(String cellBarcode, Cell cell) {
    try {
      if (cell.cellCode != cellBarcode) {
        emit(state.copyWith(
            status: FullInventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: 'Відскановано не ту комірку'));
        return false;
      }
      return true;
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
      rethrow;
    }
  }

  scanNom(String nomBarcode, Inventory nom) {
    try {
      for (var barcode in nom.barcodes) {
        if (barcode.barcode == nomBarcode) {
          emit(state.copyWith(
              count: state.count + barcode.ratio,
              status: FullInventoryStatus.success,
              nomBarcode: nomBarcode));
          return;
        }
      }
      emit(state.copyWith(
          status: FullInventoryStatus.notFound,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: 'Відскановано не той товар'));
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
    }
  }

  Future<void> sendNom(String nomBarcode, int count, String docNumber,
      String nomStatus, String cellBarcode) async {
    try {
      final nom = await FullInventoryRepository().getNomData(
          'Full_Inventory_sku_scan',
          '$nomBarcode $count $docNumber $nomStatus $cellBarcode');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: FullInventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: FullInventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
    }
  }

  void manualCountIncrement(String count) {
    emit(state.copyWith(
      count: int.parse(count),
      status: FullInventoryStatus.success,
    ));
  }

  void clear() {
    emit(state.copyWith(
        count: 0,
        errorMassage: '',
        nomBarcode: '',
        status: FullInventoryStatus.success));
  }

  Future<void> addToCell(String nomBarcode, String docNumber,
      String cellBarcode, String nomStatus) async {
    try {
      final nom = await FullInventoryRepository().getNomData(
          'Add_row_to_Full_Inventory',
          '$nomBarcode $docNumber $nomStatus $cellBarcode');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: FullInventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: FullInventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: FullInventoryStatus.failure));
    }
  }
}
