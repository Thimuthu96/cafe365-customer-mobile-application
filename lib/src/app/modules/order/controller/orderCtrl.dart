import 'dart:convert';

import '../models/orderData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/consts/constants.dart';

class OrderController extends GetxController {
  final RxList orders = <OrderData>[].obs;
  final RxBool isLoading = false.obs;

  //get my orders items
  Future<void> fetchMyOrders(String uuid) async {
    debugPrint('#####%%%####');
    debugPrint(uuid);
    debugPrint('#########');

    try {
      isLoading.value = true;
      orders.clear();
      var url = Uri.parse('$BASE_URL/orderstatus-by-user/$uuid');
      var res = await http.get(url);
      if (res.statusCode == 200) {
        final String jsonData = res.body;
        List<dynamic> orderDataMap = jsonDecode(jsonData);
        orders.addAll(
            orderDataMap.map((item) => OrderData.fromMap(item)).toList());
        debugPrint('#########');
        debugPrint(orders.length.toString());
        debugPrint('#########');
      } else {
        throw Exception(
            'Something went wrong! Status code : ${res.statusCode}');
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
      throw err;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOrderSuccessMail(String email, String name, String OrderId,
      String orderDate, String orderPrice) async {
    try {
      var url = Uri.parse(
          '$BASE_URL/order-success/$email/$name/$OrderId/$orderDate/$orderPrice');
      var res = await http.post(url);
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong smtp $err');
      debugPrint('***********');
      throw err;
    }
  }
}
