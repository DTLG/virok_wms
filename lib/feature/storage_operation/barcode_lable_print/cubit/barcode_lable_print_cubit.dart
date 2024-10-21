import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../services/printer/printer.dart';
import '../barcode_lable_print_repo/barcode_lable_print_repo.dart';
import '../barcode_lable_print_repo/models/barcodes_noms.dart';

part 'barcode_lable_print_state.dart';

class BarcodeLablePrintCubit extends Cubit<BarcodeLablePrintState> {
  BarcodeLablePrintCubit() : super(const BarcodeLablePrintState());

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
        ? PrinterLables.nomLableEAN14(barcode, nom.article, nom.name, 1)
        : PrinterLables.nomLableEAN13(barcode, nom.article, nom.name, 1));
  }

  void clear() {
    emit(state.copyWith(
        status: BarcodeLablePrintStatus.initial,
        noms: BarcodesNoms.empty,
        errorMassage: ''));
  }
}
