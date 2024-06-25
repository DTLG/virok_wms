

import 'package:virok_wms/feature/moving/moving_in/moving_in_repository/models/order.dart';

import '../moving_in_client/moving_in_api_client.dart';

class MovingInHeadRepository {
  MovingInHeadRepository({MovingInDataClient? movingInDataClient})
      : _movingInDataClient =movingInDataClient ?? MovingInDataClient();

  final MovingInDataClient _movingInDataClient;

  Future<MovingInOrders> getOrders(String query, String body) async {
    final listNom = await _movingInDataClient.getOrders(query, body);

    final List<MovingInOrder> orders = listNom.orders
        .map((e) => MovingInOrder(
            docId: e.docId ?? '',
            date: e.date ?? '',
            customer: e.customer ?? '', 
            invoice: e.invoice ?? ''
            ))
        .toList();
    return MovingInOrders(orders: orders, status: listNom.status ?? 1);
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
