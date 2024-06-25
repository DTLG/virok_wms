import 'package:virok_wms/models/order.dart';

import '../selection_client/selection_api_client.dart';

class SelectionOrderHeadRepository {
  SelectionOrderHeadRepository({SelectionOrderDataClient? selectionApiClient})
      : _selectionApiClient = selectionApiClient ?? SelectionOrderDataClient();

  final SelectionOrderDataClient _selectionApiClient;

  Future<Orders> getOrders(String query, String body) async {
    final listNom = await _selectionApiClient.getOrders(query, body);

    final List<Order> orders = listNom.orders
        .map(
          (e) => Order(
              docId: e.docId ?? '',
              date: e.date ?? '',
              baskets:
                  e.baskets.map((e) => Bascet(bascet: e.basket ?? '')).toList(),
              fullOrder: e.fullOrdfer ?? 0,
              importanceMark: e.importanceMark ?? 0,
              mMark: e.mMark ?? 0,
              newPostMark: e.newPostMark ?? 0),
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
