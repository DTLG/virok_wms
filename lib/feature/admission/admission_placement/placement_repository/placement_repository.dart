import 'package:virok_wms/feature/admission/admission_placement/placement_api_client/placement_api_client.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/admission_nom.dart';
import 'package:virok_wms/models/barcode_model.dart';

class PlacementRepository {
  PlacementRepository({PlacementApiClient? placementApiClient})
      : _placementApiClient = placementApiClient ?? PlacementApiClient();

  final PlacementApiClient _placementApiClient;

  Future<AdmissionNoms> getNoms(String query, String body) async {
    final listNom = await _placementApiClient.getNoms(query, body);

    return AdmissionNoms(
        noms: listNom.noms
            .map((e) => AdmissionNom(
                incomingInvoice: e.incomingInvoice ?? '',
                date: e.date ?? '',
                customer: e.customer ?? '',
                name: e.name ?? '',
                qty: e.qty ?? 0,
                article: e.article ?? '',
                barcodes: e.barcodes
                    .map((b) =>
                        Barcode(barcode: b.barcode ?? '', ratio: b.ratio ?? 1))
                    .toList(),
                count: e.count ?? 0,
                task: e.task ?? 0,
                nameCell: e.nameCell ?? '',
                codeCell: e.codeCell ?? ''))
            .toList());
  }
  
}
