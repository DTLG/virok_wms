import 'package:virok_wms/feature/admission/admission_placement/placement_api_client/placement_api_client.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/placement_nom.dart';
import 'package:virok_wms/models/barcode_model.dart';

class PlacementRepository {
  PlacementRepository({PlacementApiClient? placementApiClient})
      : _placementApiClient = placementApiClient ?? PlacementApiClient();

  final PlacementApiClient _placementApiClient;

  Future<PlacementNoms> getNoms(String query, String body) async {
    final listNom = await _placementApiClient.getNoms(query, body);

    return PlacementNoms(
        noms: listNom.noms
            .map((e) => PlacementNom(
     
                name: e.name ?? '',
                
                article: e.article ?? '',
                barcodes: e.barcodes
                    .map((b) =>
                        Barcode(barcode: b.barcode ?? '', ratio: b.ratio ?? 1))
                    .toList(),
                    freeCount: e.freeCount ?? 0,
                    allCount: e.allCount ?? 0,
                    reservedCount: e.reservedCount ?? 0
         ),
         )
            .toList(),
            errorMassage: listNom.errorMassage ?? '');
  }

  Future<PlacementNom> getNom(String query, String body) async {
    final nom = await _placementApiClient.getNom(query, body);

    return  PlacementNom(
     
                name: nom.name ?? '',
                
                article: nom.article ?? '',
                barcodes: nom.barcodes
                    .map((b) =>
                        Barcode(barcode: b.barcode ?? '', ratio: b.ratio ?? 1))
                    .toList(),
                    freeCount: nom.freeCount ?? 0,
                    allCount: nom.allCount ?? 0,
                    reservedCount: nom.reservedCount ?? 0
         );
  }
}
