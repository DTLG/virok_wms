import 'package:virok_wms/models/models.dart';

import '../../../../models/barcode_model.dart';
import '../moving_out_client/moving_out_api_client.dart';

class MovingGateOrderDataRepository {
  MovingGateOrderDataRepository({MovingOutOrderDataClient? selectionApiClient})
      : _selectionApiClient = selectionApiClient ?? MovingOutOrderDataClient();

  final MovingOutOrderDataClient _selectionApiClient;

  Future<Noms> movingRepo(String query, String body) async {
    final listNom = await _selectionApiClient.movingApi(query, body);

    List<Nom> noms = listNom.noms
        .map((nom) => Nom(
            name: nom.name ?? '',
            article: nom.article ?? '',
            barcode: nom.barcodes
                .map((e) =>
                    Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                .toList(),
            baskets: (nom.baskets ?? [])
                .map((b) =>
                    Bascket(bascket: b.basket ?? '', name: b.basketName ?? ''))
                .toList(),
            nameCell: nom.nameCell ?? '',
            codeCell: nom.codeCell ?? '',
            cells: (nom.cells ?? [CellDTO(codeCell: '', nameCell: '')])
                .map((e) => Cell(
                    codeCell: e.codeCell ?? '', nameCell: e.nameCell ?? ''))
                .toList(),
            table: nom.table ?? '',
            docNumber: nom.docNumber ?? '',
            qty: nom.qty ?? 0,
            count: nom.count ?? 0,
            isMyne: nom.itsMyne ?? 0,
            taskNumber: nom.taskNumber ?? '',
            statusNom: nom.statusNom ?? ''))
        .toList();
    return Noms(noms: noms, status: listNom.status ?? 1);
  }

  Future<Nom> getNom(String query, String body) async {
    final nom = await _selectionApiClient.getNom(query, body);

    return Nom(
        name: nom.name ?? '',
        article: nom.article ?? '',
        barcode: nom.barcodes
            .map((e) => Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
            .toList(),
        baskets: (nom.baskets ?? [])
            .map((b) =>
                Bascket(bascket: b.basket ?? '', name: b.basketName ?? ''))
            .toList(),
        nameCell: nom.nameCell ?? '',
        codeCell: nom.codeCell ?? '',
        cells: (nom.cells ?? [CellDTO(codeCell: '', nameCell: '')])
            .map((e) =>
                Cell(codeCell: e.codeCell ?? '', nameCell: e.nameCell ?? ''))
            .toList(),
        table: nom.table ?? '',
        docNumber: nom.docNumber ?? '',
        qty: nom.qty ?? 0,
        count: nom.count ?? 0,
        isMyne: nom.itsMyne ?? 0,
        taskNumber: nom.taskNumber ?? '',
        statusNom: nom.statusNom ?? '');
  }
}
