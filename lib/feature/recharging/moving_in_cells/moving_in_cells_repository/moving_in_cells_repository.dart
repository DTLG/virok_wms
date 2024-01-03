

import 'package:virok_wms/feature/recharging/moving_in_cells/moving_in_cells_client/moving_in_cells_client.dart';
import 'package:virok_wms/models/barcode_model.dart';
import 'package:virok_wms/models/check_cell.dart';

class MovingInCellsRepository {
  MovingInCellsRepository({MovingInCellClient? movingInCellClient})
      : _movingInCellClient = movingInCellClient ?? MovingInCellClient();

  final MovingInCellClient _movingInCellClient;

  Future<CheckCell> getCellData(String query,String body) async {
    final ceel = await _movingInCellClient.getCeel(query, body);

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

    Future<String> send(String query,String body) async {
    final res = await _movingInCellClient.send(query, body);

    return res ?? 'Помилка';
  }
}
