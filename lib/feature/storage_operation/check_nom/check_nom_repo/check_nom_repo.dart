
import '../check_nom_client/check_nom_client.dart';
import 'models/barcodes_noms.dart' ;

class ChackNomRepository {
  ChackNomRepository({ChackNomClient? chackNomClient})
      : _chackNomClient = chackNomClient ?? ChackNomClient();

  final ChackNomClient _chackNomClient;

  Future<BarcodesNoms> getNoms(String query, String body) async {
    final nomsDTO = await _chackNomClient.getNoms(query, body);
    List<BarcodesNom> noms = nomsDTO.noms
        .map(
          (nom) => BarcodesNom(
              name: nom.name ?? '',
              article: nom.article ?? '',
              barodes: nom.barcodes
                  .map((bar) => Barcode(
                      barcode: bar.barcode ?? '',
                      count: bar.count ?? 1,
                      ratio: bar.ratio ?? 1))
                  .toList(),
              cells: nom.cells
                  .map((c) => Cell(
                      codeCell: c.codeCell ?? '', nameCell: c.nameCell ?? '',count: c.count ?? 0))
                  .toList()),
        )
        .toList();
    return BarcodesNoms(noms: noms);
  }

   Future<int> insertGenerationBarcode(String query, String body) async {
    final status = await _chackNomClient.insertGenerationBarcode(query, body);
  
    return  status ?? 1;
  }
}
