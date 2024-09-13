class CheckOutModel {
  String? UserId;
  String? Name;
  String? Mobile;
  String? HouseAddress;
  String? Town;

  CheckOutModel({
    this.UserId,
    this.Name,
    this.Mobile,
    this.HouseAddress,
    this.Town,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId,
      'Name': Name,
      'Mobile': Mobile,
      'HouseAddress': HouseAddress,
      'Town': Town,
    };
  }

  CheckOutModel.fromMap(Map<String, dynamic> checkoutItem) {
    UserId = checkoutItem['UserId'];
    Name = checkoutItem['Name'];
    Mobile = checkoutItem['Mobile'];
    HouseAddress = checkoutItem['HouseAddress'];
    Town = checkoutItem['Town'];
  }
}
