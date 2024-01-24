import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/inventory/inventory_data_repository/inventory_repository.dart';
import 'package:virok_wms/feature/inventory/models/inventory.dart';

part 'inventory_data_state.dart';

class InventoryDataCubit extends Cubit<InventoryDataState> {
  InventoryDataCubit() : super(InventoryDataState());

  Future<void> getNom(String barcode, String docNumber) async {
    try {
      final nom = await InventoryRepository()
          .getNomData('Full_Inventory_sku_data', '$barcode $docNumber');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  bool scanCell(String cellBarcode, Cell cell) {
    try {
      if (cell.cellCode != cellBarcode) {
        emit(state.copyWith(
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch,
            errorMassage: 'Відскановано не ту комірку'));
        return false;
      }
      return true;
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
      rethrow;
    }
  }

  scanNom(String nomBarcode, Inventory nom) {
    try {
      for (var barcode in nom.barcodes) {
        if (barcode.barcode == nomBarcode) {
          emit(state.copyWith(
              count: state.count + barcode.ratio,
              status: InventoryStatus.success,
              nomBarcode: nomBarcode));
          return;
        }
      }
      emit(state.copyWith(
          status: InventoryStatus.notFound,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: 'Відскановано не той товар'));
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  Future<void> sendNom(String nomBarcode, int count, String docNumber,
      String cellBarcode) async {
    try {
      final nom = await InventoryRepository().getNomData(
          'Full_Inventory_sku_scan',
          '$nomBarcode $count $docNumber $cellBarcode');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }

  void manualCountIncrement(String count) {
    emit(state.copyWith(
      count: int.parse(count),
      status: InventoryStatus.success,
    ));
  }

  void clear() {
    emit(state.copyWith(count: 0, errorMassage: '', nomBarcode: '',
    status: InventoryStatus.success));
  }


    Future<void> addToCell(String nomBarcode,  String docNumber,
      String cellBarcode) async {
    try {
      final nom = await InventoryRepository().getNomData(
          'Add_row_to_Full_Inventory',
          '$nomBarcode $docNumber $cellBarcode');
      if (nom.errorMassage == 'OK') {
        emit(state.copyWith(nom: nom, status: InventoryStatus.success));
      } else {
        emit(state.copyWith(
            errorMassage: nom.errorMassage,
            status: InventoryStatus.notFound,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(status: InventoryStatus.failure));
    }
  }


}
