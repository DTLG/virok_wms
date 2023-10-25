import '../check_basket_client/check_basket_client.dart';
import 'models/basket_info.dart';

class CheckBasketRepository {
  CheckBasketRepository({CheckBasketApiClient? checkBasketApiClient})
      : _checkBasketApiClient = checkBasketApiClient ?? CheckBasketApiClient();

  final CheckBasketApiClient _checkBasketApiClient;

  Future<BasketData> getBasketInfo(String barcode) async {
    final data = await _checkBasketApiClient.getBasketInfo(barcode);
    return BasketData(
        docNumber: data.docNumber ?? '',
        table: Table(
            name: data.table.name ?? '', barcode: data.table.barcode ?? ''),
        basket: data.basket ?? '');
  }
}
