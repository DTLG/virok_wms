

import '../moving_in_client/moving_in_api_client.dart';
import 'models/noms_model.dart';

class MovingInDataRepository {
  MovingInDataRepository(
      {MovingInDataClient? movingInDataClient})
      : _movingInDataClient =
            movingInDataClient ?? MovingInDataClient();

  final MovingInDataClient _movingInDataClient;

  Future<MovingInNoms> movingInRepo(String query, String body) async {
    final listNom = await _movingInDataClient.movingInApi(query, body);

    List<MovingInNom> noms = listNom.noms
        .map((nom) => MovingInNom(
              number: nom.number ?? '',
              name: nom.name ?? '',
              article: nom.article ?? '',
              barcodes: nom.barcodes
                  .map((e) =>
                      Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                  .toList(),
              qty: nom.qty ?? 0,
              count: nom.count ?? 0,
            ))
        .toList();
    return MovingInNoms(
        noms: noms,
        invoice: listNom.invoice ?? '',
        errorMassage: listNom.errorMassage ?? 'Ok');
  }
}
