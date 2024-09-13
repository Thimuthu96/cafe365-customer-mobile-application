// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cafe_365_app/src/app/modules/biller/model/billModel.dart';
import 'package:cafe_365_app/src/core/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cartItemModel.dart';

class CartController extends GetxController {
  final RxList cartItems = <CartItemModel>[].obs;
  final RxList bill = <Biller>[].obs;
  final RxBool isLoading = false.obs;
  final RxString userID = "".obs;
  final RxDouble subtotal = 0.0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //Get check and add cart items
  Future<void> addCartItems(
    BuildContext context,
    String userId,
    String ItemName,
    String ItemImage,
    double Price,
    String itemId,
  ) async {
    String Id = userId;
    String uuid = Id.replaceAll('"', '');
    cartItems.clear();
    try {
      isLoading.value = true;

      var url = Uri.parse('$BASE_URL/cart-item-availability/$uuid/$itemId');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> cartMap = jsonDecode(res.body);
        cartItems.addAll(
            cartMap.map((item) => CartItemModel.fromMap(item)).toList());

        if (cartItems.isEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var url = Uri.parse('${BASE_URL}cart/create');
          late http.Response res;
          var dataJson = {
            "UserId": uuid,
            "ItemName": ItemName,
            "ItemImage": ItemImage,
            "Price": Price.toString(),
            "Quantity": 1,
            "ItemId": itemId,
          };

          // Convert dataJson to a JSON-encoded string
          String jsonData = jsonEncode(dataJson);

          try {
            ///--------send POST request
            res = await http.post(url, body: jsonData, headers: {
              'Content-Type': 'application/json',
            });

            //check response status code
            if (res.statusCode == 200) {
              scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
                content: Text(
                  'Added to the cart!',
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
          } catch (err) {
            debugPrint('***********');
            debugPrint('Something went wrong $err');
            debugPrint('***********');
          }
        } else {
          int qnt = cartItems[0].Quantity + 1;
          var url = Uri.parse('$BASE_URL/cart/update/${cartItems[0].id}/$qnt');
          var res = await http.put(url);

          if (res.statusCode == 200) {
            scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
              content: Text(
                'Cart item increased!',
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
        }
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var url = Uri.parse('${BASE_URL}cart/create');
        late http.Response res;
        var dataJson = {
          "UserId": uuid,
          "ItemName": ItemName,
          "ItemImage": ItemImage,
          "Price": Price.toString(),
          "Quantity": 1,
          "ItemId": itemId,
        };
        // Convert dataJson to a JSON-encoded string
        String jsonData = jsonEncode(dataJson);
        try {
          ///--------send POST request
          res = await http.post(url, body: jsonData, headers: {
            'Content-Type': 'application/json',
          });

          //check response status code
          if (res.statusCode == 200) {
            scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
              content: Text(
                'Added to the cart!',
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
        } catch (err) {
          debugPrint('***********');
          debugPrint('Something went wrong $err');
          debugPrint('***********');
        }
      }
    } catch (e) {
      debugPrint('Error fetching products');
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //Get cart items
  Future<void> getCartItems() async {
    String Id = userID.value;
    String uuid = Id.replaceAll('"', '');
    cartItems.clear();
    try {
      isLoading.value = true;

      var url = Uri.parse('$BASE_URL/cart-items/$uuid');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> cartMap = jsonDecode(res.body);
        cartItems.addAll(
            cartMap.map((item) => CartItemModel.fromMap(item)).toList());
      }
    } catch (e) {
      debugPrint('Error fetching products');
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //Cart item update
  Future<void> updateCartItem(String id, int qnt) async {
    var url = Uri.parse('$BASE_URL/cart/update/$id/$qnt');

    try {
      isLoading.value = false;
      var res = await http.put(url);
      if (res.statusCode == 200) {
        await getCartItems();
        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text(
            'Cart item updated!',
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

  //Cart item delete
  Future<void> deleteCartItem(String id) async {
    var url = Uri.parse('$BASE_URL/cart/delete/$id');

    try {
      isLoading.value = false;
      var res = await http.delete(url);
      if (res.statusCode == 200) {
        await getCartItems();
        scaffoldMessengerKey.currentState?.showSnackBar(const SnackBar(
          content: Text(
            'Cart item removed!',
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

  //biller
  Future<void> getBillAmount() async {
    String Id = userID.value;
    String uuid = Id.replaceAll('"', '');
    bill.clear();
    try {
      isLoading.value = true;

      var url = Uri.parse('$BASE_URL/cart-prices/$uuid');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> billMap = jsonDecode(res.body);
        bill.addAll(billMap.map((item) => Biller.fromMap(item)).toList());
      }
    } catch (e) {
      debugPrint('Error fetching cartbill');
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  //Cart item delete
  Future<void> cartClean(String uuid) async {
    var url = Uri.parse('$BASE_URL/cart/remove/$uuid');

    try {
      isLoading.value = false;
      var res = await http.delete(url);
      if (res.statusCode == 200) {
        await getCartItems();
      } else {}
    } catch (e) {
      debugPrint('Error fetching products');
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
