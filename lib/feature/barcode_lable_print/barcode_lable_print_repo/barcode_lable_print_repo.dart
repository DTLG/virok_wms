import '../barcode_lable_print_client/barcode_lable_print_client.dart';
import 'models/barcodes_noms.dart';

class BarcodeLablePrintRepo {
  BarcodeLablePrintRepo({BarcodeLablePrintCLient? barcodeLablePrintCLient})
      : _barcodeLablePrintCLient =
            barcodeLablePrintCLient ?? BarcodeLablePrintCLient();

  final BarcodeLablePrintCLient _barcodeLablePrintCLient;

  Future<BarcodesNoms> getNoms(String query, String body) async {
    final nomsDTO = await _barcodeLablePrintCLient.getNoms(query, body);
    List<BarcodesNom> noms = nomsDTO.noms
        .map((nom) => BarcodesNom(
            name: nom.name ?? '',
            article: nom.article ?? '',
            barodes: nom.barcodes
                .map((bar) => Barcode(
                    barcode: bar.barcode ?? '',
                    count: bar.count ?? 1,
                    ratio: bar.ratio ?? 1))
                .toList()))
        .toList();
    return BarcodesNoms(noms: noms);
  }
}
