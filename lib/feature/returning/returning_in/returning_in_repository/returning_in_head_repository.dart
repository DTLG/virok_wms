import 'package:virok_wms/feature/returning/returning_in/returning_in_repository/models/order.dart';
import 'package:virok_wms/feature/returning/returning_in/returning_in_client/returning_in_api_client.dart';


class ReturningInHeadRepository {
  ReturningInHeadRepository({ReturningInDataClient? returningInDataClient})
      : _returningInDataClient = returningInDataClient ?? ReturningInDataClient();

  final ReturningInDataClient _returningInDataClient;

  Future<ReturningInOrders> getOrders(String query, String body) async {
    final listNom = await _returningInDataClient.getOrders(query, body);

    final List<ReturningInOrder> orders = listNom.orders
        .map((e) => ReturningInOrder(
            docId: e.docId ?? '',
            date: e.date ?? '',
            customer: e.customer ?? '', 
            invoice: e.invoice ?? ''
            ))
        .toList();
    return ReturningInOrders(orders: orders, status: listNom.status ?? 1);
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
