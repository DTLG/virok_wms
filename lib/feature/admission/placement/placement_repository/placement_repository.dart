import 'package:virok_wms/feature/admission/placement/placement_api_client/placement_api_client.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/admission_nom.dart';
import 'package:virok_wms/feature/admission/placement/placement_repository/model/placement_order.dart';
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
                taskNumber: e.taskNumber ?? '',
                customer: e.customer ?? '',
                name: e.name ?? '',
                qty: e.qty ?? 0,
                article: e.article ?? '',
                barcodes: e.barcodes
                    .map((b) => Barcode(
                        barcode: b.barcode ?? '',
                        ratio: b.ratio?.toDouble() ?? 1))
                    .toList(),
                count: e.count ?? 0,
                task: e.task ?? 0,
                nameCell: e.nameCell ?? '',
                codeCell: e.codeCell ?? ''))
            .toList());
  }

  Future<AdmissionNom> getNom(String query, String body) async {
    final nom = await _placementApiClient.getNom(query, body);

    return AdmissionNom(
        incomingInvoice: nom.incomingInvoice ?? '',
        date: nom.date ?? '',
        taskNumber: nom.taskNumber ?? '',
        customer: nom.customer ?? '',
        name: nom.name ?? '',
        qty: nom.qty ?? 0,
        article: nom.article ?? '',
        barcodes: nom.barcodes
            .map((b) => Barcode(
                barcode: b.barcode ?? '', ratio: b.ratio?.toDouble() ?? 1))
            .toList(),
        count: nom.count ?? 0,
        task: nom.task ?? 0,
        nameCell: nom.nameCell ?? '',
        codeCell: nom.codeCell ?? '');
  }

  Future<PlacementOrders> getOrders(String query, String body) async {
    final orders = await _placementApiClient.getOrders(query, body);

    return PlacementOrders(
        orders: orders.orders
            .map((e) => PlacementOrder(
                incomingInvoice: e.incomingInvoice ?? '', date: e.date ?? ''))
            .toList(),
        errorMassage: orders.errorMassage ?? '');
  }
}
