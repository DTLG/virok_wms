class LabelInfo {
  final String regionShort;
  final String customer;
  final String address;
  final String dateNumber;
  final String orderDateNumber;
  final String customerGroup;
  final String barcode;
  final String errorMassage;
  final String comment;
  final String pickup_type;

  LabelInfo({
    required this.regionShort,
    required this.customer,
    required this.address,
    required this.dateNumber,
    required this.orderDateNumber,
    required this.customerGroup,
    required this.barcode,
    required this.errorMassage,
    required this.comment,
    required this.pickup_type,
  });

  factory LabelInfo.fromJson(Map<String, dynamic> json) {
    return LabelInfo(
      regionShort: json['region_short'] ?? '',
      customer: json['customer'] ?? '',
      address: json['address'] ?? '',
      dateNumber: json['date_number'] ?? '',
      orderDateNumber: json['order_date_number'] ?? '',
      customerGroup: json['customer_group'] ?? '',
      barcode: json['barcode'] ?? '',
      pickup_type: json['pickup_type'] ?? '',
      comment: json['comment'] ?? '',
      errorMassage: json['ErrorMassage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region_short': regionShort,
      'customer': customer,
      'address': address,
      'date_number': dateNumber,
      'order_date_number': orderDateNumber,
      'customer_group': customerGroup,
      'barcode': barcode,
      'comment': comment,
      'pickup_type': pickup_type,
      'ErrorMassage': errorMassage,
    };
  }

  static final empty = LabelInfo(
    regionShort: '',
    customer: '',
    address: '',
    dateNumber: '',
    orderDateNumber: '',
    comment: '',
    customerGroup: '',
    barcode: '',
    errorMassage: '',
    pickup_type: '',
  );
}
