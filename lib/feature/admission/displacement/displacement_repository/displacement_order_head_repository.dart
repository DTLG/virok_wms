
import 'package:virok_wms/feature/admission/displacement/displacement_repository/models/order.dart';

import '../displacement_client/displacement_api_client.dart';

class DiplacementOrderHeadRepository {
  DiplacementOrderHeadRepository({DisplacementOrderDataClient? displacementApiClient})
      : _displacementApiClient = displacementApiClient ?? DisplacementOrderDataClient();

  final DisplacementOrderDataClient _displacementApiClient;

  Future<DisplacementOrders> getOrders(String query, String body) async {
    final listNom = await _displacementApiClient.getOrders(query, body);

    final List<DisplacementOrder> orders = listNom.orders
        .map((e) => DisplacementOrder(
            docId: e.docId ?? '',
            date: e.date ?? '',
            customer: e.customer ?? '', 
            invoice: e.invoice ?? ''
            ))
        .toList();
    return DisplacementOrders(orders: orders, status: listNom.status ?? 1);
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
