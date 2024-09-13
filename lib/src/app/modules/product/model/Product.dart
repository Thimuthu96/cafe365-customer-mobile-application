class Product {
  String? id;
  bool? Availability;
  String? ItemImage;
  String? Category;
  int? Price;
  String? ItemName;
  String? Id;

  Product({
    this.id,
    this.Availability,
    this.ItemImage,
    this.Category,
    this.Price,
    this.ItemName,
    this.Id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Availability': Availability,
      'ItemImage': ItemImage,
      'Category': Category,
      'Price': Price,
      'ItemName': ItemName,
      'Id': Id,
    };
  }

  Product.fromMap(Map<String, dynamic> product) {
    id = product['id'];
    Availability = product['Availability'];
    ItemImage = product['ItemImage'];
    Category = product['Category'];
    Price = product['Price'];
    ItemName = product['ItemName'];
    Id = product['Id'];
  }
}
