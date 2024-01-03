import 'package:virok_wms/models/order.dart';

import '../returning_out_client/returning_out_api_client.dart';

class ReturningOutOrderHeadRepository {
  ReturningOutOrderHeadRepository({ReturningOutOrderDataClient? movingOrderDataClient})
      : _movingOrderDataClient = movingOrderDataClient ?? ReturningOutOrderDataClient();

  final ReturningOutOrderDataClient _movingOrderDataClient;

  Future<Orders> getReturningList(String query, String body) async {
    final listNom = await _movingOrderDataClient.getReturningList(query, body);

    final List<Order> orders = listNom.orders
        .map((e) => Order(
            docId: e.docId ?? '',
            date: e.date ?? '',
            baskets:
                e.baskets.map((e) => Bascet(bascet: e.basket ?? '')).toList(),fullOrder: e.fullOrdfer ?? 0))
        .toList();
    return Orders(orders: orders, status: listNom.status ?? 1);
  }


}
