class Order {
  final String uniqueID;
  final String items;
  final double totalPrice;
  final int itemCount;
  Order(
      {required this.uniqueID,
      required this.items,
      required this.totalPrice,
      required this.itemCount});

  Order.fromMap(Map<dynamic, dynamic> data)
      : uniqueID = data['uniqueID'],
        items = data['items'],
        totalPrice = data['totalPrice'],
        itemCount = data['itemCount'];
}
