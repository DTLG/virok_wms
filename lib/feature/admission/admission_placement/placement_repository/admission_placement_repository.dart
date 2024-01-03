import 'package:virok_wms/feature/admission/admission_placement/placement_api_client/admission_placement_client.dart';
import 'package:virok_wms/feature/admission/admission_placement/placement_repository/model/admission_placement_nom.dart';
import 'package:virok_wms/models/barcode_model.dart';

class AdmissionPlacementRepository {
  AdmissionPlacementRepository({AdmissionPlacementClient? placementApiClient})
      : _placementApiClient = placementApiClient ?? AdmissionPlacementClient();

  final AdmissionPlacementClient _placementApiClient;

  Future<AdmissionNoms> getNoms(String query, String body) async {
    final listNom = await _placementApiClient.getNoms(query, body);

    return AdmissionNoms(
        noms: listNom.noms
            .map((e) => AdmissionNom(
                taskNumber: e.taskNumber ?? '',
                date: e.date ?? '',
                name: e.name ?? '',
                qty: e.qty ?? 0,
                article: e.article ?? '',
                barcodes: e.barcodes
                    .map((b) =>
                        Barcode(barcode: b.barcode ?? '', ratio: b.ratio ?? 1))
                    .toList(),
                count: e.count ?? 0,
                nameCell: e.nameCell ?? '',
                codeCell: e.codeCell ?? ''))
            .toList(),
            errorMassage: '');
  }

  Future<AdmissionNom> getNom(String query, String body) async {
    final nom = await _placementApiClient.getNom(query, body);

    return AdmissionNom(
        taskNumber: nom.taskNumber ?? '',
        date: nom.date ?? '',
        name: nom.name ?? '',
        qty: nom.qty ?? 0,
        article: nom.article ?? '',
        barcodes: nom.barcodes
            .map((b) => Barcode(barcode: b.barcode ?? '', ratio: b.ratio ?? 1))
            .toList(),
        count: nom.count ?? 0,
        nameCell: nom.nameCell ?? '',
        codeCell: nom.codeCell ?? '');
  }
}
