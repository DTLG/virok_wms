import 'package:virok_wms/feature/storage_operation/check_cell/check_cell_repository/model/check_cell_model.dart';

import '../../../../models/barcode_model.dart';
import '../ceck_cell_client/ceck_cell_client.dart';

class CheckCellRepository {
  CheckCellRepository({CheckCellClient? cellClient})
      : _cellClient = cellClient ?? CheckCellClient();

  final CheckCellClient _cellClient;

  Future<CheckCell> getCellData(String query,String body) async {
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
}
