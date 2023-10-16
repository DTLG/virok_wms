import 'package:virok_wms/feature/selection/selection_api_client/selection_api_client.dart';

import '../../../models/noms_model.dart';

class SelectionRepository {
  SelectionRepository({SelectionApiClient? selectionApiClient})
      : _selectionApiClient = selectionApiClient ?? SelectionApiClient();

  final SelectionApiClient _selectionApiClient;

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
}
