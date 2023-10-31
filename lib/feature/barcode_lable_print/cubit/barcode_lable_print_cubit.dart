import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/barcode_lable_print/barcode_lable_print_repo/barcode_lable_print_repo.dart';
import 'package:virok_wms/feature/barcode_lable_print/barcode_lable_print_repo/models/barcodes_noms.dart';

import '../../../services/printer/connect_printer.dart';

part 'barcode_lable_print_state.dart';

class BarcodeLablePrintCubit extends Cubit<BarcodeLablePrintState> {
  BarcodeLablePrintCubit() : super(BarcodeLablePrintState());

  Future<void> getNoms(String query, String value) async {
    try {
      if (value.length > 4) {
        final noms = await BarcodeLablePrintRepo().getNoms(query, value);
        emit(state.copyWith(
            status: BarcodeLablePrintStatus.success, noms: noms));
      }
    } catch (e) {
      emit(state.copyWith(
          status: BarcodeLablePrintStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> printLable(BarcodesNom nom, String barcode, int ratio) async {
    PrinterConnect().connectToPrinter(barcode.length == 14
        ? lableEAN14(barcode, nom.article, nom.name)
        : lableEAN13(barcode, nom.article, nom.name));
  }
}

String lableEAN13(String barcode, String article, String name) {
  return '''
SIZE 50 mm,30 mm
GAP 3 mm, 0
DIRECTION 1,0
DENSITY 8
CLS
BLOCK 15,15,380,120,"2",0,1,1,1,1,"${name.replaceAll(RegExp('[\\"]'), '')}"
TEXT 15,115,"4",0,1,1,1,"Арт:$article"
BARCODE 200,160, "EAN13",60,2,0,2,2,2, "$barcode"
PRINT 1

''';
}

String lableEAN14(String barcode, String article, String name) {
 List<String> b = barcode.split('');
 b.removeLast();
  return '''
SIZE 50 mm,30 mm
GAP 3 mm, 0
DIRECTION 1,0
DENSITY 8
CLS
BLOCK 15,15,380,120,"2",0,1,1,1,1,"${name.replaceAll(RegExp('[\\"]'), '')}"
TEXT 15,115,"4",0,1,1,1,"Арт:$article"
BARCODE 200,150, "ITF14",70,2,0,2,5,2, "$barcode"
"
PRINT 1

''';
}
