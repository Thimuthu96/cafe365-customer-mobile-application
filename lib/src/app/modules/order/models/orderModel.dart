import 'orderDetailsModel.dart';

class OrderModel {
  String? OrderId = "";
  String? Price = "";
  String? State = "";
  String? Table = "";
  String? Date = "";
  String? Time = "";
  String? uuid = "";
  List<OrderDetails> orderDetails;

  OrderModel({
    required this.OrderId,
    required this.Price,
    required this.State,
    required this.Table,
    required this.Date,
    required this.Time,
    required this.uuid,
    required this.orderDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      OrderId: json['OrderId'] as String,
      Price: json['Price'] as String,
      State: json['State'] as String,
      Table: json['Table'] as String,
      Date: json['Date'] as String,
      Time: json['Time'] as String,
      uuid: json['uuid'] as String,
      orderDetails: json['data'] != null
          ? (json['data'] as List).map((e) => OrderDetails.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'OrderId': OrderId,
        'Price': Price,
        'State': State,
        'Table': Table,
        'Date': Date,
        'Time': Time,
        'uuid': uuid,
        'orderDetails': List<OrderDetails>.from(
            orderDetails.map((e) => e.toJson()).toList()),
      };
}
