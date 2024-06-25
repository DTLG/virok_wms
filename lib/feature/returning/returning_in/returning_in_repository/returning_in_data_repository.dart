import 'package:virok_wms/feature/returning/returning_in/returning_in_client/returning_in_api_client.dart';

import 'models/noms_model.dart';

class ReturningInDataRepository {
  ReturningInDataRepository({ReturningInDataClient? returningInDataClient})
      : _returningInDataClient =
            returningInDataClient ?? ReturningInDataClient();

  final ReturningInDataClient _returningInDataClient;

  Future<ReturningInNoms> getNoms(String query, String body) async {
    final listNom = await _returningInDataClient.getNoms(query, body);

    List<ReturningInNom> noms = listNom.noms
        .map((nom) => ReturningInNom(
              number: nom.number ?? '',
              name: nom.name ?? '',
              article: nom.article ?? '',
              barcode: nom.barcodes
                  .map((e) =>
                      Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                  .toList(),
              qty: nom.qty ?? 0,
              count: nom.count ?? 0, nomStatus: '',
            ))
        .toList();
    return ReturningInNoms(
        noms: noms,
        invoice: listNom.invoice ?? '',
        errorMassage: listNom.errorMassage ?? 'Ok');
  }

  Future<ReturningInNom> getNom(String query, String body) async {
    final nom = await _returningInDataClient.getNom(query, body);
    return ReturningInNom(
      number: nom.number ?? '',
      name: nom.name ?? '',
      article: nom.article ?? '',
      barcode: nom.barcodes
          .map((e) => Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
          .toList(),
      qty: nom.qty ?? 0,
      count: nom.count ?? 0, nomStatus: '',
    );
  }
}
