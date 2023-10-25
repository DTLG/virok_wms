import 'package:virok_wms/models/models.dart';

import '../selection_client/selection_api_client.dart';

class SelectionOrderDataRepository {
  SelectionOrderDataRepository({SelectionOrderDataClient? selectionApiClient})
      : _selectionApiClient = selectionApiClient ?? SelectionOrderDataClient();

  final SelectionOrderDataClient _selectionApiClient;

  Future<Noms> selectionRepo(String query, String body) async {
    final listNom = await _selectionApiClient.selectionApi(query, body);

    List<Nom> noms = listNom.noms
        .map((nom) => Nom(
            name: nom.name ?? '',
            article: nom.article ?? '',
            barcode: nom.barcodes
                .map((e) =>
                    Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                .toList(),
            basckets: (nom.baskets ?? [])
                .map((b) =>
                    Bascket(bascket: b.basket ?? '', name: b.basketName ?? ''))
                .toList(),
            nameCell: nom.nameCell ?? '',
            codeCell: nom.codeCell ?? '',
            table: nom.table ?? '',
            docNumber: nom.docNumber ?? '',
            qty: nom.qty ?? 0,
            count: nom.count ?? 0,
            isMyne: nom.itsMyne ?? 0))
        .toList();
    return Noms(noms: noms, status: listNom.status ?? 1);
  }
}
