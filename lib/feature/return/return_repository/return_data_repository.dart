import 'package:virok_wms/feature/return/return_client/return_api_client.dart';

import 'models/noms_model.dart';

class ReturnDataRepository {
  ReturnDataRepository({ReturnDataClient? returningInDataClient})
      : _returningInDataClient =
            returningInDataClient ?? ReturnDataClient();

  final ReturnDataClient _returningInDataClient;

  Future<ReturnNoms> getNoms(String query, String body) async {
    final listNom = await _returningInDataClient.getNoms(query, body);

    List<ReturnNom> noms = listNom.noms
        .map((nom) => ReturnNom(
              number: nom.number ?? '',
              name: nom.name ?? '',
              article: nom.article ?? '',
              barcode: nom.barcodes
                  .map((e) =>
                      Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                  .toList(),
              qty: nom.qty ?? 0,
              count: nom.count ?? 0, nomStatus: nom.nomStatus ?? '',
            ))
        .toList();
    return ReturnNoms(
        noms: noms,
        invoice: listNom.invoice ?? '',
        errorMassage: listNom.errorMassage ?? 'Ok');
  }

  Future<ReturnNom> getNom(String query, String body) async {
    final nom = await _returningInDataClient.getNom(query, body);
    return ReturnNom(
      number: nom.number ?? '',
      name: nom.name ?? '',
      article: nom.article ?? '',
      barcode: nom.barcodes
          .map((e) => Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
          .toList(),
      qty: nom.qty ?? 0,
      count: nom.count ?? 0, nomStatus: nom.nomStatus ?? '',
    );
  }
}
