class Biller {
  String? SubTotal;
  String? discount;
  String? Total;

  Biller({
    this.SubTotal,
    this.discount,
    this.Total,
  });

  Map<String, dynamic> toMap() {
    return {
      'SubTotal': SubTotal,
      'discount': discount,
      'Total': Total,
    };
  }

  Biller.fromMap(Map<String, dynamic> biller) {
    SubTotal = biller['SubTotal'];
    discount = biller['discount'];
    Total = biller['Total'];
  }
}
