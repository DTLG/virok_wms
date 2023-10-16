import 'package:virok_wms/feature/shipment_orders/shipment_orders_repository/models/orders.dart';
import 'package:virok_wms/models/models.dart';

import '../shipment_orders_client/shipment_order_client.dart';

class ShipmentRepository {
  ShipmentRepository({ShipmentApiClient? shipmentApiClient})
      : _shipmentApiClient = shipmentApiClient ?? ShipmentApiClient();

  final ShipmentApiClient _shipmentApiClient;

  Future<Orders> getOrders() async {
    final listOrder = await _shipmentApiClient.getOrders();

    List<Order> orders = listOrder.orders
        .map((order) =>
            Order(docId: order.docId, date: order.date, client: order.client))
        .toList();

    return Orders(orders: orders);
  }
  Future<Noms> getOrder(String docId) async {
    final listNom = await _shipmentApiClient.getOrder(docId);

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

    return Noms(noms: noms, status: listNom.status ?? 0);
  }
}
