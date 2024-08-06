import 'package:virok_wms/feature/storage_operation/check_nom/models/barcodes_noms.dart'
    as chackNom;
import 'package:virok_wms/models/check_cell.dart';

import '../../../../models/barcode_model.dart';
import '../ceck_cell_client/ceck_cell_client.dart';

class CheckCellRepository {
  CheckCellRepository({CheckCellClient? cellClient})
      : _cellClient = cellClient ?? CheckCellClient();

  final CheckCellClient _cellClient;

  Future<CheckCell> getCellData(String query, String body) async {
    final ceel = await _cellClient.getCeel(query, body);

    return CheckCell(
        codCell: ceel.codCell ?? '',
        nameCell: ceel.nameCell ?? '',
        noms: ceel.noms
            .map((e) => Nom(
                name: e.name ?? '',
                article: e.article ?? '',
                qty: e.qty ?? 0,
                minRest: e.minRest ?? 0,
                barcodes: e.barcodes
                    .map((e) => Barcode(
                        barcode: e.barcode ?? '',
                        ratio: e.ratio?.toDouble() ?? 1))
                    .toList()))
            .toList(),
        errorMasssage: ceel.errorMasssage ?? '');
  }

  Future<chackNom.Noms> getNoms(String query, String body) async {
    final nomsDTO = await _cellClient.getNoms(query, body);
    List<chackNom.BarcodesNom> noms = nomsDTO.noms
        .map(
          (nom) => chackNom.BarcodesNom(
            name: nom.name,
            article: nom.article,
            barcodes: nom.barcodes
                .map((bar) => chackNom.Barcode(
                    barcode: bar.barcode, count: bar.count, ratio: bar.ratio))
                .toList(),
            cells: nom.cells
                .map((c) => chackNom.Cell(
                    codeCell: c.codeCell,
                    nameCell: c.nameCell,
                    count: c.count,
                    nomStatus: c.nomStatus))
                .toList(),
          ),
        )
        .toList();
    return chackNom.Noms(noms: noms);
  }
}
