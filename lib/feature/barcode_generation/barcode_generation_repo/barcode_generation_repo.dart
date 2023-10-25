import 'package:virok_wms/feature/barcode_generation/api_client/bar_gen_api_client.dart';
import 'package:virok_wms/models/models.dart';

class BarcodeGenerationRepo {
  BarcodeGenerationRepo(
      {BarcodeGenerationApiCLient? barcodeGenerationApiCLient})
      : _barcodeGenerationApiCLient =
            barcodeGenerationApiCLient ?? BarcodeGenerationApiCLient();

  final BarcodeGenerationApiCLient _barcodeGenerationApiCLient;

  Future<Noms> genBarRepo(String query, String body) async {
    final nomsDTO = await _barcodeGenerationApiCLient.genBarApi(query, body);
    List<Nom> noms = nomsDTO.noms
        .map((nom) => Nom(
            name: nom.name ?? '',
            article: nom.article ?? '',
            barcode: nom.barcodes.map((e) => Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1)).toList(),
            basckets: [],
            nameCell: '',
            codeCell: '',
            docNumber: '',
            isMyne: 0,
            table: '',
            qty: 0,
            count: 0))
        .toList();
    return Noms(noms: noms, status: nomsDTO.status ?? 0);
  }
}
