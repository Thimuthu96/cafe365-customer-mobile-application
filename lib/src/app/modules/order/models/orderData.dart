class OrderData {
  String? OrderId;
  String? Price;
  String? State;

  OrderData({
    this.OrderId,
    this.Price,
    this.State,
  });

  Map<String, dynamic> toMap() {
    return {
      'OrderId': OrderId,
      'Price': Price,
      'State': State,
    };
  }

  OrderData.fromMap(Map<String, dynamic> orderData) {
    OrderId = orderData['OrderId'];
    Price = orderData['Price'];
    State = orderData['State'];
  }
}
