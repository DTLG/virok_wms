import 'package:virok_wms/models/models.dart';

import '../selection_order_data_client/selection_order_data_client.dart';

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
            barcode: nom.barcode ?? '',
            nameCell: nom.nameCell ?? '',
            codeCell: nom.codeCell ?? '',
            docId: nom.docId ?? '',
            qty: nom.qty ?? 0,
            count: nom.count ?? 0))
        .toList();
    return Noms(noms: noms, status: listNom.status ?? 1);
  }

  Future<Map> updateStatus(String docId) async {
    final status = await _selectionApiClient.updateStatus(docId);

    return {
      "status": status['status'],
      "error_massage": status['error_massage']
    };
  }
}
