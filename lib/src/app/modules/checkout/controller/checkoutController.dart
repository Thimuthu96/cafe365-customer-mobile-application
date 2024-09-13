// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cafe_365_app/src/app/modules/checkout/models/checkoutModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/consts/constants.dart';

class CheckOutController extends GetxController {
  final RxBool isLoading = false.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  addCheckoutInfo(BuildContext context, CheckOutModel checkOutModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('${BASE_URL}checkout/create');
    late http.Response res;
    final dataJson = jsonEncode(checkOutModel.toMap());
    try {
      isLoading.value = true;

      ///--------send POST request
      res = await http.post(url, body: dataJson, headers: {
        'Content-Type': 'application/json',
      });
      //check response status code
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Delivery info edded!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
        Map<String, dynamic> jsonResponse = jsonDecode(res.body);

        // Extract the checkoutItemId
        String checkoutItemId = jsonResponse['checkoutItemId'];

        // Use the checkoutItemId as needed
        debugPrint("#####checkout#####");
        debugPrint('checkoutItemId: $checkoutItemId');
        debugPrint("###############");
        await prefs.setString(CHECKOUT_ID, checkoutItemId);
      } else {
        debugPrint(
            'POST request failed with status code : ${res.statusCode} ${res.body}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Something went wrong!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    } finally {
      isLoading.value = false;
    }
  }

  //update loyalty points
  Future<void> updateLoyaltyPoints(String uuid, String points) async {
    var url = Uri.parse('$BASE_URL/loyalty-points/$uuid/$points');

    try {
      isLoading.value = false;
      var res = await http.put(url);
      if (res.statusCode == 200) {
        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text(
            'Your points added to an account!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text(
            'Something went wrong!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          closeIconColor: Colors.blueGrey,
        ));
      }
    } catch (e) {
      debugPrint('Error fetching products');
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
