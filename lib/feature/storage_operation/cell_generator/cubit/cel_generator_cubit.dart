import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/services/printer/connect_printer.dart';


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

  Future<void> printLable() async {
    final barcode =
        'M${state.floor}${state.range}${state.rack}${state.floorRack}${state.cell}';
    final title = 'M${state.floor}-${state.range}-';
    final subtitle = '${state.rack}-${state.floorRack}-${state.cell}';

    PrinterConnect().connectToPrinter(lable(barcode, title, subtitle));
  }
}

extension on int {
  String get toStr {
    return this < 10 ? '0$this' : toString();
  }
}

String lable(String barcode, String title, String subTitle) {
  return '''
SIZE 100 mm,70 mm
GAP 3 mm, 0
DIRECTION 1,0
DENSITY 8
CLS
QRCODE 83,80,M,15,A,0,M2, "$barcode"
TEXT 80,430,"0",0,30,30,"$title"
TEXT 360,420,"0",0,40,40,"$subTitle"


PRINT 1

''';
}
