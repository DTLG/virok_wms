import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/recharging/moving_in_cells/moving_in_cells_repository/Moving_in_cells_repository.dart';
import 'package:virok_wms/models/check_cell.dart';

part 'moving_in_cells_state.dart';

class MovingInCellsCubit extends Cubit<MovingInCellsState> {
  MovingInCellsCubit() : super(MovingInCellsState());

  Future<bool> getCellTake(String barcode) async {
    try {
      final cell =
          await MovingInCellsRepository().getCellData('cell_data', barcode);
      if (cell.errorMasssage == 'OK') {
        emit(state.copyWith(
            status: MovingInCellsStatus.success,
            cell: cell,
            cellTake: barcode,
            cellTakeName: cell.nameCell));
        return true;
      } else {
        emit(state.copyWith(
            status: MovingInCellsStatus.notFound,
            cell: cell,
            cellTake: '',
            time: DateTime.now().microsecondsSinceEpoch,
            errorMassage: cell.errorMasssage));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
          status: MovingInCellsStatus.failure, errorMassage: e.toString()));
      rethrow;
    }
  }

  scanNom(String nomBarcode) {
    bool notFound = true;

    if (state.nom == Nom.empty) {
      for (var nom in state.cell.noms) {
        for (var barcode in nom.barcodes) {
          if (barcode.barcode == nomBarcode) {
            emit(state.copyWith(nom: nom));
            if (state.count + barcode.ratio > nom.qty) {
              emit(state.copyWith(
                  status: MovingInCellsStatus.notFound,
                  time: DateTime.now().microsecondsSinceEpoch,
                  errorMassage:
                      'Введена більша кількість.\n Доступна кількість: ${state.nom.qty}'));
              notFound = false;
              break;
            } else {
              emit(state.copyWith(
                  status: MovingInCellsStatus.success,
                  nom: nom,
                  count: state.count + barcode.ratio));
              notFound = false;
            }
            break;
          } else {
            notFound = true;
          }
        }
        if (notFound == false) {
          break;
        }
      }
    } else {
      for (var barcode in state.nom.barcodes) {
        if (barcode.barcode == nomBarcode) {
          if (state.count + barcode.ratio > state.nom.qty) {
            emit(
              state.copyWith(
                status: MovingInCellsStatus.notFound,
                time: DateTime.now().microsecondsSinceEpoch,
                errorMassage:
                    'Введена більша кількість.\n Доступна кількість: ${state.nom.qty}',
              ),
            );
            notFound = false;

            break;
          } else {
            emit(state.copyWith(
                status: MovingInCellsStatus.success,
                count: state.count + barcode.ratio));
            notFound = false;
            break;
          }
        } else {
          notFound = true;
        }
      }
    }
    if (notFound == true) {
      emit(state.copyWith(
          status: MovingInCellsStatus.notFound,
          time: DateTime.now().microsecondsSinceEpoch,
          errorMassage: 'Відскановано не той товар'));
    }
  }

  manualCountIncrement(int newCount) {
    if (newCount > state.nom.qty) {
      emit(state.copyWith(
          status: MovingInCellsStatus.notFound,
          time: DateTime.now().microsecondsSinceEpoch,
          errorMassage:
              'Введена більша кількість.\n Доступна кількість: ${state.nom.qty}'));
      return;
    }

    emit(state.copyWith(
        status: MovingInCellsStatus.success, count: newCount.toInt()));
  }

  setNomStatus(String nomStatus) {
    emit(state.copyWith(
      nomStatus: nomStatus,
      time: DateTime.now().millisecondsSinceEpoch,
      status: MovingInCellsStatus.success,
    ));
  }

  Future<bool> getCellPut(String barcode) async {
    try {
      final cell =
          await MovingInCellsRepository().getCellData('cell_data', barcode);
      if (cell.errorMasssage == 'OK') {
        emit(state.copyWith(
            status: MovingInCellsStatus.success, cell: cell, cellPut: barcode));
        return true;
      } else {
        emit(state.copyWith(
            status: MovingInCellsStatus.notFound,
            cell: cell,
            time: DateTime.now().microsecondsSinceEpoch,
            errorMassage: cell.errorMasssage));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
          status: MovingInCellsStatus.failure, errorMassage: e.toString()));
      rethrow;
    }
  }

  Future<void> send() async {
    String body =
        '${state.nom.barcodes.first.barcode} ${state.count} ${state.nomStatus} ${state.cellTake} ${state.cellPut}';
    try {
      emit(state.copyWith(status: MovingInCellsStatus.loading));
      final res = await MovingInCellsRepository().send('move_sku', body);
      res == 'OK'
          ? emit(state.copyWith(
              status: MovingInCellsStatus.initial,
              cell: CheckCell.empty,
              cellPut: '',
              cellTake: '',
              count: 0,
              nomStatus: 'Кондиція',
              nom: Nom.empty,
              errorMassage: ''))
          : emit(state.copyWith(
              status: MovingInCellsStatus.notFound,
              errorMassage: res,
              time: DateTime.now().millisecondsSinceEpoch,
              cellPut: ''));
    } catch (e) {
      emit(state.copyWith(
          status: MovingInCellsStatus.failure, errorMassage: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(
        status: MovingInCellsStatus.initial,
        cell: CheckCell.empty,
        cellPut: '',
        cellTake: '',
        count: 0,
        nom: Nom.empty,
        errorMassage: '',
        nomStatus: 'Кондиція'));
  }
}
