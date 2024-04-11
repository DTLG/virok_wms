class PlacementOrders {
  final List<PlacementOrder> orders;
  final String errorMassage;

  PlacementOrders({required this.orders, required this.errorMassage});

static final empty = PlacementOrders(orders: [], errorMassage: '');
}

class PlacementOrder {
  final String incomingInvoice;
  final String date;

  PlacementOrder({required this.incomingInvoice, required this.date});
}
