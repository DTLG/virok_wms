import 'package:virok_wms/feature/storage_operation/check_nom/check_nom_repo/models/barcodes_noms.dart';
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
                    .map((e) =>
                        Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                    .toList()))
            .toList(),
        errorMasssage: ceel.errorMasssage ?? '');
  }

  Future<BarcodesNoms> getNoms(String query, String body) async {
    final nomsDTO = await _cellClient.getNoms(query, body);
    List<BarcodesNom> noms = nomsDTO.noms
        .map(
          (nom) => BarcodesNom(
              name: nom.name ?? '',
              article: nom.article ?? '',
              barodes: nom.barcodes
                  .map((bar) => Barcodee(
                      barcode: bar.barcode ?? '',
                      count: bar.count ?? 1,
                      ratio: bar.ratio ?? 1))
                  .toList(),
              cells: nom.cells
                  .map((c) => Cell(
                      codeCell: c.codeCell ?? '',
                      nameCell: c.nameCell ?? '',
                      count: c.count ?? 0))
                  .toList(),
                  totalCount: 0),
        )
        .toList();
    return BarcodesNoms(noms: noms);
  }
}
