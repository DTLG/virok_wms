import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../services/printer/printer.dart';

part 'cel_generator_state.dart';

class CelLGeneratorCubit extends Cubit<CellGeneratorState> {
  CelLGeneratorCubit() : super(const CellGeneratorState());

  void setFloor(int value) {
    emit(state.copyWith(floor: value.toStr));
  }

  void setRange(int value) {
    emit(state.copyWith(range: value.toStr));
  }

  void setRack(int value) {
    emit(state.copyWith(rack: value.toStr));
  }

  void setFloorRack(int value) {
    emit(state.copyWith(floorRack: value.toStr));
  }

  void setCell(int value) {
    emit(state.copyWith(cell: value.toStr));
  }

  Future<void> printMezoninLable() async {
    final barcode =
        'M${state.floor}${state.range}${state.rack}${state.floorRack}${state.cell}';
    final title = 'M${state.floor} ${state.range} ';
    final subtitle = '${state.rack} ${state.floorRack} ${state.cell}';
    final errowUp = state.floorRack == '04'?true:false;

    PrinterConnect().connectToPrinter(
        PrinterLables.mezoninCellLable(barcode, title, subtitle, errowUp));
  }

  Future<void> printPalletLable() async {
    final barcode =
        '${state.range}${state.rack}${state.floorRack}${state.cell}';
    final title =
        '${state.range} ${state.rack} ${state.floorRack} ${state.cell}';

    PrinterConnect().connectToPrinter(PrinterLables.palletCellLable(
      barcode,
      title,
    ));
  }

    Future<void> printServiceLable() async {
    final barcode =
        'S${state.floor}${state.range}${state.rack}${state.floorRack}${state.cell}';
    final title = 'S${state.floor} ${state.range} ';
    final subtitle = '${state.rack} ${state.floorRack} ${state.cell}';
    final errowUp = state.floorRack == '04'?true:false;

    PrinterConnect().connectToPrinter(
        PrinterLables.serviceCellLable(barcode, title, subtitle, errowUp));
  }

}




extension on int {
  String get toStr {
    return this < 10 ? '0$this' : toString();
  }
}

