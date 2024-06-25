import 'package:virok_wms/models/order.dart';

import '../moving_out_client/moving_gate_api_client.dart';

class MovingGateOrderHeadRepository {
  MovingGateOrderHeadRepository(
      {MovingGateOrderDataClient? movingOrderDataClient})
      : _movingOrderDataClient =
            movingOrderDataClient ?? MovingGateOrderDataClient();

  final MovingGateOrderDataClient _movingOrderDataClient;

  Future<Orders> getOrders(String query, String body) async {
    final listNom = await _movingOrderDataClient.getOrders(query, body);

    final List<Order> orders = listNom.orders
        .map(
          (e) => Order(
              docId: e.docId ?? '',
              date: e.date ?? '',
              baskets:
                  e.baskets.map((e) => Bascet(bascet: e.basket ?? '')).toList(),
              fullOrder: e.fullOrdfer ?? 0,
              importanceMark: e.importanceMark ?? 0,
                    mMark: e.mMark ?? 0, newPostMark: e.newPostMark ?? 0),
              
        )
        .toList();
    return Orders(orders: orders, status: listNom.status ?? 1);
  }
}
