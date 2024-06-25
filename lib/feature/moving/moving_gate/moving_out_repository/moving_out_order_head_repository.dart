import 'package:virok_wms/models/order.dart';

import '../moving_out_client/moving_out_api_client.dart';

class MovingOutOrderHeadRepository {
  MovingOutOrderHeadRepository(
      {MovingOutOrderDataClient? movingOrderDataClient})
      : _movingOrderDataClient =
            movingOrderDataClient ?? MovingOutOrderDataClient();

  final MovingOutOrderDataClient _movingOrderDataClient;

  Future<Orders> getMovingList(String query, String body) async {
    final listNom = await _movingOrderDataClient.getMovingList(query, body);

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

  // Future<Baskets> getOrderBaskets(String docId) async {
  //   final baskets = await _selectionApiClient.getOrderBasket(docId);

  //   return Baskets(
  //       basket: baskets.basket
  //           .map((e) =>
  //               Basket(basket: e.basket ?? '', basketName: e.basketName ?? ''))
  //           .toList());
  // }
}
