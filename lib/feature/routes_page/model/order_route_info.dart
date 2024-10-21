class OrderRouteInfo {
  final String orderNumber;
  final int orderPlacesCount;
  final int scannedCount;
  final String orderBarcode;
  final String orderRouteName;
  final String docId;
  final String docGuid;
  final String docStatus;
  final String errorMessage;

  OrderRouteInfo({
    required this.orderNumber,
    required this.orderPlacesCount,
    required this.scannedCount,
    required this.orderBarcode,
    required this.orderRouteName,
    required this.docId,
    required this.docGuid,
    required this.docStatus,
    required this.errorMessage,
  });

  factory OrderRouteInfo.fromJson(Map<String, dynamic> json) {
    return OrderRouteInfo(
      orderNumber: json['order_number'],
      orderPlacesCount: json['order_places_count'],
      scannedCount: json['scanned_count'],
      orderBarcode: json['order_barcode'],
      orderRouteName: json['order_route_name'],
      docId: json['doc_id'],
      docGuid: json['doc_guid'],
      docStatus: json['doc_status'],
      errorMessage: json['ErrorMassage'],
    );
  }
}
