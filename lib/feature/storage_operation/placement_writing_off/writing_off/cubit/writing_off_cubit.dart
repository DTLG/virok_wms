import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../placement_writeing_off_repository/model/cell_model.dart';
import '../../placement_writeing_off_repository/placement_writeing_off_repository.dart';

part 'writing_off_state.dart';

class WritingOffCubit extends Cubit<WritingOffState> {
  WritingOffCubit() : super(const WritingOffState());

  Future<double> getCeel(String barcode) async {
    try {
      final cell = await PlacementWritingOffRepo().getCeel(barcode);
      if (cell.cell.first.status == 0) {
        emit(state.copyWith(cellStatus: 1));
        emit(state.copyWith(status: WritingOffStatus.notFound, cellStatus: 0));
      } else {
        emit(state.copyWith(
            status: WritingOffStatus.success,
            cell: cell,
            cellBarcode: barcode,
            cellStatus: 1));
      }

      return cell.cell.first.status;
    } catch (e) {
      emit(state.copyWith(
          status: WritingOffStatus.failure, error: e.toString()));
      rethrow;
    }
  }

  void addNom(String nomBarcode) {
    double count = state.count;
    bool isEqual = false;

    if (state.cell.zone == 1) {
      for (var element in state.cell.cell.first.barcodes) {
        if (element == nomBarcode) {
          isEqual = true;
          break;
        } else {
          isEqual = false;
        }
      }

      if (isEqual == true) {
        if (count == state.cell.cell.first.quantity) {
          emit(state.copyWith(cellStatus: 1));
          emit(
              state.copyWith(status: WritingOffStatus.notFound, cellStatus: 5));
        } else {
          count++;
          emit(state.copyWith(
              status: WritingOffStatus.success,
              count: count,
              cellStatus: 1,
              nomBarcode: nomBarcode));
        }
      } else {
        emit(state.copyWith(cellStatus: 1));
        emit(state.copyWith(status: WritingOffStatus.notFound, cellStatus: 3));
      }
    } else {
      //-------------------------------------------------------

      String name = '';
      double qty = 0;
      String article = '';
      for (final cell in state.cell.cell) {
        for (final barcode in cell.barcodes) {
          if (barcode == nomBarcode) {
            name = cell.name;
            qty = double.parse(cell.quantity.toString());
            article = cell.article;
            if (state.name.isEmpty) {
              emit(state.copyWith(name: name));
            }
            isEqual = true;

            break;
          } else {
            isEqual = false;
          }
        }
        if (isEqual) {
          break;
        }
      }
      if (isEqual == false) {
        emit(state.copyWith(
          status: WritingOffStatus.notFound,
          cellStatus: 3,
        ));
        emit(state.copyWith(cellStatus: 1));
        return;
      }

      if (name.isNotEmpty && state.name == name) {
        if (count == qty) {
          emit(state.copyWith(cellStatus: 1));
          emit(
              state.copyWith(status: WritingOffStatus.notFound, cellStatus: 5));
        } else {
          count++;
          emit(state.copyWith(
              status: WritingOffStatus.success,
              count: count,
              name: name,
              article: article,
              qty: qty,
              nomBarcode: nomBarcode));
        }
      } else {
        emit(state.copyWith(
          status: WritingOffStatus.notFound,
          cellStatus: 6,
        ));
        emit(state.copyWith(cellStatus: 1));
      }
    }
  }

  void manualAddNom(CellData cell) {
    emit(state.copyWith(
        status: WritingOffStatus.success,
        count: 1,
        name: cell.name,
        article: cell.article,
        qty: double.parse(cell.quantity.toString()),
        nomBarcode: cell.barcodes.first));
  }

  void manualCountIncrement(String nomBarcode, String count) {
    dynamic qty =
        state.cell.zone == 1 ? state.cell.cell.first.quantity : state.qty;
    if (double.parse(count) > qty) {
      emit(state.copyWith(cellStatus: 1));
      emit(state.copyWith(status: WritingOffStatus.notFound, cellStatus: 5));
    } else {
      emit(state.copyWith(count: double.parse(count), cellStatus: 1));
    }
  }

  Future<void> sendNom(String ceel, String nom, String count) async {
    try {
      emit(state.copyWith(cellStatus: 1));
      emit(state.copyWith(status: WritingOffStatus.loading));
      final cell = await PlacementWritingOffRepo().sendNom(
        'writing_off',
        nom,
        count,
        ceel,
      );

      emit(state.copyWith(
          status: WritingOffStatus.success,
          cell: cell,
          count: 0,
          nomBarcode: nom,
          cellStatus: 1));

      Future.delayed(const Duration(seconds: 2), () {
        clear();
      });
    } catch (e) {
      emit(state.copyWith(
          status: WritingOffStatus.failure, error: e.toString()));
    }
  }

  void clear() {
    emit(state.copyWith(cellStatus: 1));

    emit(state.copyWith(
        status: WritingOffStatus.initial,
        nomBarcode: '',
        cellBarcode: '',
        count: 0,
        name: '',
        article: '',
        qty: 0,
        cell: Cell.empty));
  }
}
