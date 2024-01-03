import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/printer/connect_printer.dart';
import '../check_nom_repo/check_nom_repo.dart';
import '../check_nom_repo/models/barcodes_noms.dart';

part 'nom_operations_state.dart';

class NomOperationsCubit extends Cubit<NomOperationsState> {
  NomOperationsCubit() : super(const NomOperationsState());

  Future<void> getNom(String query, String value) async {
    try {
      BarcodesNom nomenklatura = BarcodesNom.empty;
      final noms = await ChackNomRepository().getNoms(query, value);
      for (var nom in noms.noms) {
        if (nom.article == value) {
          nomenklatura = nom;
        }
      }

      emit(state.copyWith(
        status: NomOperationsStatus.success,
        nom: nomenklatura,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: NomOperationsStatus.failure, errorMassage: e.toString()));
    }
  }

  Future<void> sendBar(String query, String body,String article) async {
    final status = await ChackNomRepository().insertGenerationBarcode(
        query, body);

    if (status == 1) {
      emit(state.copyWith(status: NomOperationsStatus.success));
    } else if (status == 2) {
      emit(state.copyWith(
          status: NomOperationsStatus.error,
          errorMassage: 'Штрихкод належить цьому товару'));
    } else if (status == 0) {
      emit(state.copyWith(
          status: NomOperationsStatus.error,
          errorMassage: 'Штрихкод належить іншому товару'));
    }
    await getNom('get_from_article', article);
  }

  Future<void> printLable(BarcodesNom nom, String barcode, int ratio) async {
    PrinterConnect().connectToPrinter(barcode.length == 14
        ? lableEAN14(barcode, nom.article, nom.name)
        : lableEAN13(barcode, nom.article, nom.name));
  }

    Future<void> getActivButton() async {
    final prefs = await SharedPreferences.getInstance();
    final bool genBarButton = prefs.getBool('generation_bar_button') ?? false;
        final bool barcodeLablePrintButton = prefs.getBool('barcode_print_lable_button') ?? false;


 

    emit(state.copyWith(
      barcodeGenerationButton: genBarButton,
      barcodeLablePrintButton:barcodeLablePrintButton));
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
