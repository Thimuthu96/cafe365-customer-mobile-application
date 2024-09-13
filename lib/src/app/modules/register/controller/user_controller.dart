// ignore_for_file: use_build_context_synchronously

import 'package:cafe_365_app/src/core/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserController extends GetxController {
  final RxList userList = <User>[].obs;
  final RxString userName = "".obs;
  final RxDouble userPoints = 0.0.obs;

  //--------------Add new user
  addUser(BuildContext context, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('${BASE_URL}user-register');
    late http.Response res;
    late http.Response response;
    final dataJson = jsonEncode(user.toMap());
    try {
      ///--------send POST request
      res = await http.post(url, body: dataJson, headers: {
        'Content-Type': 'application/json',
      });
      //check response status code
      if (res.statusCode == 200) {
        var url = Uri.parse('${BASE_URL}user-id/${user.email}');
        response = await http.get(url, headers: {
          'Content-Type': 'application/json',
        });
        if (response.statusCode == 200) {
          final String userId = response.body;
          await prefs.setString(UUID, userId);
          if (user != null) {
            await prefs.setString(UUID, userId);
          }

          //navigate to login
          Navigator.pushNamed(context, "/login");

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'User signup successful!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(milliseconds: 2000),
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            closeIconColor: Colors.blueGrey,
          ));
        }
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
    }
  }

  //-------Get user id and name
  Future<void> fetchUserId(BuildContext context, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${BASE_URL}user-id/$email');
    var url1 = Uri.parse('${BASE_URL}user-name/$email');
    await prefs.setString(EMAIL, email);
    late http.Response res;
    late http.Response res2;
    try {
      res = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      res2 = await http.get(url1, headers: {
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        final String userId = res.body;
        await prefs.setString(UUID, userId);

        if (res2.statusCode == 200) {
          final String userName = (res2.body).replaceAll('"', '');
          await prefs.setString(USER_NAME, userName);
        }

        debugPrint("*********************");
        debugPrint(prefs.getString(UUID) ?? "User ID not found");
        debugPrint("*********************");

        debugPrint("#####################");
        debugPrint(prefs.getString(USER_NAME) ?? "User name not found");
        debugPrint("#####################");
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }

  //--------Get loyalty points
  Future<double> fetchUserLoyaltyPoints(BuildContext context, uuid) async {
    var url = Uri.parse('${BASE_URL}points/$uuid');
    late http.Response res;
    try {
      res = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        // Remove double quotes from the response body before parsing as double
        String pointsString = res.body.replaceAll('"', '');
        userPoints.value = double.parse(pointsString);

        debugPrint("*********************");
        debugPrint(userPoints.value.toString());
        debugPrint("*********************");
        return double.parse(pointsString);
      }
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
      return 0;
    }
    return 0;
  }
}
