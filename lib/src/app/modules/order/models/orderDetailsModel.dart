class OrderDetails {
  String? ItemName;
  String? ItemImage;
  String? Price;
  int? Quantity;
  String? ItemId;

  OrderDetails({
    this.ItemName,
    this.ItemImage,
    this.Price,
    this.Quantity,
    this.ItemId,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      ItemName: json['ItemName'] as String,
      ItemImage: json['ItemImage'] as String,
      Price: json['Price'] as String,
      Quantity: json['Quantity'] as int,
      ItemId: json['ItemId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'ItemName': ItemName,
        'ItemImage': ItemImage,
        'Price': Price,
        'Quantity': Quantity,
        'ItemId': ItemId,
      };
}
