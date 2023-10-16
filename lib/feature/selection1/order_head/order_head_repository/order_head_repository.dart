import 'package:virok_wms/feature/selection1/order_head/order_head_client/order_head_client.dart';
import 'package:virok_wms/models/orders.dart';

class SelectionOrderHeadRepository {
  SelectionOrderHeadRepository(
      {SelectionOrderHeadClient? selectionOrderHeadClient})
      : _selectionOrderHeadClient =
            selectionOrderHeadClient ?? SelectionOrderHeadClient();

  final SelectionOrderHeadClient _selectionOrderHeadClient;

  Future<Orders> getOrders(String query, String body) async {
    final listOrder = await _selectionOrderHeadClient.getOrders(query, body);

    List<Order> orders = listOrder.orders
        .map((order) =>
            Order(docId: order.docId ?? '', date: order.date ?? '', client: order.client ?? ''))
        .toList();

    return Orders(orders: orders);
  }
}
