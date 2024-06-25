import 'package:virok_wms/models/order.dart';

import '../returning_out_client/returning_out_api_client.dart';

class ReturningOutOrderHeadRepository {
  ReturningOutOrderHeadRepository(
      {ReturningOutOrderDataClient? movingOrderDataClient})
      : _movingOrderDataClient =
            movingOrderDataClient ?? ReturningOutOrderDataClient();

  final ReturningOutOrderDataClient _movingOrderDataClient;

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
