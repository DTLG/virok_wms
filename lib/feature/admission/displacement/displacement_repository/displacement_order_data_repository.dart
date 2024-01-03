import 'package:virok_wms/feature/admission/displacement/displacement_repository/models/noms_model.dart';

import '../displacement_client/displacement_api_client.dart';

class DisplacementOrderDataRepository {
  DisplacementOrderDataRepository(
      {DisplacementOrderDataClient? displacementApiClient})
      : _displacementApiClient =
            displacementApiClient ?? DisplacementOrderDataClient();

  final DisplacementOrderDataClient _displacementApiClient;

  Future<DisplacementNoms> getNoms(String query, String body) async {
    final listNom = await _displacementApiClient.getNoms(query, body);

    List<DisplacementNom> noms = listNom.noms
        .map((nom) => DisplacementNom(
              number: nom.number ?? '',
              name: nom.name ?? '',
              article: nom.article ?? '',
              barcode: (nom.barcodes ?? [])
                  .map((e) =>
                      Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
                  .toList(),
              qty: nom.qty ?? 0,
              count: nom.count ?? 0,
            ))
        .toList();
    return DisplacementNoms(
        noms: noms,
        invoice: listNom.invoice ?? '',
        errorMassage: listNom.errorMassage ?? 'Ok');
  }

  Future<DisplacementNom> getNom(String query, String body) async {
    final nom = await _displacementApiClient.getNom(query, body);

    return DisplacementNom(
      number: nom.number ?? '',
      name: nom.name ?? '',
      article: nom.article ?? '',
      barcode: (nom.barcodes ?? [])
          .map((e) => Barcode(barcode: e.barcode ?? '', ratio: e.ratio ?? 1))
          .toList(),
      qty: nom.qty ?? 0,
      count: nom.count ?? 0,
    );
  }
}
