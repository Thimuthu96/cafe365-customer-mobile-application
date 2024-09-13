class CartItemModel {
  String? id;
  String? UserId;
  String? ItemName;
  String? ItemImage;
  String? Price;
  int? Quantity;
  String? ItemId;

  CartItemModel({
    this.id,
    this.UserId,
    this.ItemName,
    this.ItemImage,
    this.Price,
    this.Quantity,
    this.ItemId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'UserId': UserId,
      'ItemName': ItemName,
      'ItemImage': ItemImage,
      'Price': Price,
      'Quantity': Quantity,
      'ItemId': ItemId,
    };
  }

  CartItemModel.fromMap(Map<String, dynamic> cartItem) {
    UserId = cartItem['UserId'];
    id = cartItem['id'];
    ItemName = cartItem['ItemName'];
    ItemImage = cartItem['ItemImage'];
    Price = cartItem['Price'];
    Quantity = cartItem['Quantity'];
    ItemId = cartItem['ItemId'];
  }
}
