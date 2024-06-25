import 'package:virok_wms/feature/return/return_client/return_api_client.dart';
import 'package:virok_wms/feature/return/return_repository/models/order.dart';

class ReturnHeadRepository {
  ReturnHeadRepository({ReturnDataClient? returningInDataClient})
      : _returningInDataClient = returningInDataClient ?? ReturnDataClient();

  final ReturnDataClient _returningInDataClient;

  Future<ReturnOrders> getOrders(String query, String body) async {
    final listNom = await _returningInDataClient.getOrders(query, body);

    final List<ReturnOrder> orders = listNom.orders
        .map((e) => ReturnOrder(
            docId: e.docId ?? '',
            date: e.date ?? '',
            customer: e.customer ?? '',
            invoice: e.invoice ?? ''))
        .toList();
    return ReturnOrders(orders: orders, status: listNom.status ?? 1);
  }
}
