import 'package:virok_wms/models/order.dart';

import '../selection_client/selection_api_client.dart';

class SelectionOrderHeadRepository {
  SelectionOrderHeadRepository({SelectionOrderDataClient? selectionApiClient})
      : _selectionApiClient = selectionApiClient ?? SelectionOrderDataClient();

  final SelectionOrderDataClient _selectionApiClient;

  Future<Orders> getOrders(String query, String body) async {
    final listNom = await _selectionApiClient.getOrders(query, body);

    final List<Order> orders = listNom.orders
        .map((e) => Order(
            docId: e.docId ?? '',
            date: e.date ?? '',
            baskets:
                e.baskets.map((e) => Bascet(bascet: e.basket ?? '')).toList()))
        .toList();
    return Orders(orders: orders, status: listNom.status ?? 1);
  }
}
