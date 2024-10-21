class RouteData {
  final String docId;
  final String docGuid;
  final String routeGuid;
  final String routeName;
  final String errorMassage;
  final List<OrderData> data;

  RouteData({
    required this.docId,
    required this.docGuid,
    required this.routeGuid,
    required this.routeName,
    required this.data,
    required this.errorMassage,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? dataList = json['data'] is List ? json['data'] : null;

    List<OrderData> orderDataList = dataList != null
        ? dataList.map((item) => OrderData.fromJson(item)).toList()
        : [];

    return RouteData(
      docId: json['doc_id'] ?? '',
      routeGuid: json['route_guid'] ?? '',
      routeName: json['route_name'] ?? '',
      docGuid: json['doc_guid'] ?? '',
      errorMassage: json['ErrorMassage'] ?? '',
      data: orderDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_id': docId,
      'route_guid': routeGuid,
      'route_name': routeName,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  static RouteData empty() {
    return RouteData(
      docId: '',
      docGuid: '',
      routeGuid: '',
      routeName: '',
      errorMassage: '',
      data: [],
    );
  }
}

class OrderData {
  final String orderNumber;
  final int orderPlacesCount;
  final int scannedCount;
  final String orderBarcode;

  OrderData({
    required this.orderNumber,
    required this.orderPlacesCount,
    required this.scannedCount,
    required this.orderBarcode,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderNumber: json['order_number'],
      orderPlacesCount: json['order_places_count'],
      scannedCount: json['scanned_count'],
      orderBarcode: json['order_barcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_number': orderNumber,
      'order_places_count': orderPlacesCount,
      'scanned_count': scannedCount,
    };
  }

  static OrderData empty() {
    return OrderData(
      orderNumber: '',
      orderBarcode: '',
      orderPlacesCount: 0,
      scannedCount: 0,
    );
  }
}