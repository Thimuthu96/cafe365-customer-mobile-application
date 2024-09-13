import 'dart:convert';

import '../../product/model/Product.dart';
import '../../../../core/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final RxList products = <Product>[].obs;
  final RxList productList = <Product>[].obs;
  final RxList productsOfTime = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString timeOfTheDay = "".obs;
  final RxInt activeIndex = 0.obs;

  //get hotselling items
  Future<void> fetchHotSellingItems() async {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now).toString();

    var url = Uri.parse('$BASE_URL/fast-moving-items/$formattedDate');
    late http.Response res;
    try {
      isLoading.value = true;
      res = await http.get(url);
      if (res.statusCode == 200) {
        final String jsonString = res.body;
        List<String> productCodeMap = jsonDecode(jsonString).cast<String>();

        products.clear();
        await fetchProducts(productCodeMap);
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

  //Get all time popular item list
  Future<void> fetchAllTimePopularItems() async {
    var url = Uri.parse('$BASE_URL/alltime-popular');
    late http.Response res;
    try {
      isLoading.value = true;
      res = await http.get(url);
      if (res.statusCode == 200) {
        final String jsonString = res.body;
        List<String> productCodeMap = jsonDecode(jsonString).cast<String>();

        productList.clear();
        await fetchAlltimeBestProducts(productCodeMap);
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

  Future<void> fetchProducts(List<String> productCodeMap) async {
    for (String element in productCodeMap) {
      try {
        var url = Uri.parse('$BASE_URL/fast-move-items/$element');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> productMap = jsonDecode(response.body);
          products
              .addAll(productMap.map((item) => Product.fromMap(item)).toList());
        } else {
          debugPrint('Failed to fetch product for code: $element');
        }
      } catch (e) {
        debugPrint('Error fetching product for code: $element');
        debugPrint('Error: $e');
      }
    }
  }

  Future<void> fetchAlltimeBestProducts(List<String> productCodeMap) async {
    for (String element in productCodeMap) {
      try {
        var url = Uri.parse('$BASE_URL/fast-move-items/$element');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> productMap = jsonDecode(response.body);
          productList
              .addAll(productMap.map((item) => Product.fromMap(item)).toList());
        } else {
          debugPrint('Failed to fetch product for code: $element');
        }
      } catch (e) {
        debugPrint('Error fetching product for code: $element');
        debugPrint('Error: $e');
      }
    }
  }

  //Fetch product which that suitable for time of day
  Future<void> fetchProductForTime() async {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      timeOfTheDay.value = 'Morning';
      try {
        const String catg = "Breakfast Menu";
        const String catg1 = "test";
        const String catg2 = "test";
        var url = Uri.parse('$BASE_URL/menu-by-category/$catg/$catg1/$catg2');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          productsOfTime.clear();
          final List<dynamic> productMap = jsonDecode(response.body);
          productsOfTime
              .addAll(productMap.map((item) => Product.fromMap(item)).toList());
        } else {
          debugPrint('Failed to fetch products');
        }
      } catch (e) {
        debugPrint('Error fetching products');
        debugPrint('Error: $e');
      }
    } else if (hour >= 12 && hour < 18) {
      timeOfTheDay.value = 'Afternoon';
      try {
        const String catg = "Lunch Menu";
        const String catg1 = "Biriyani";
        const String catg2 = "Dessert";
        var url = Uri.parse('$BASE_URL/menu-by-category/$catg/$catg1/$catg2');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          productsOfTime.clear();
          final List<dynamic> productMap = jsonDecode(response.body);
          productsOfTime
              .addAll(productMap.map((item) => Product.fromMap(item)).toList());
        } else {
          debugPrint('Failed to fetch products');
        }
      } catch (e) {
        debugPrint('Error fetching products');
        debugPrint('Error: $e');
      }
    } else if (hour >= 18 && hour < 24) {
      timeOfTheDay.value = 'Evening';
      try {
        const String catg = "Soup";
        const String catg1 = "Biriyani";
        const String catg2 = "Kottu Station";
        var url = Uri.parse('$BASE_URL/menu-by-category/$catg/$catg1/$catg2');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          productsOfTime.clear();
          final List<dynamic> productMap = jsonDecode(response.body);
          productsOfTime
              .addAll(productMap.map((item) => Product.fromMap(item)).toList());
        } else {
          debugPrint('Failed to fetch products');
        }
      } catch (e) {
        debugPrint('Error fetching products');
        debugPrint('Error: $e');
      }
    } else if (hour >= 0 && hour < 6) {
      timeOfTheDay.value = 'Night';
      try {
        const String catg = "Soup";
        const String catg1 = "Biriyani";
        const String catg2 = "Kottu Station";
        var url = Uri.parse('$BASE_URL/menu-by-category/$catg/$catg1/$catg2');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          productsOfTime.clear();
          final List<dynamic> productMap = jsonDecode(response.body);
          productsOfTime
              .addAll(productMap.map((item) => Product.fromMap(item)).toList());
        } else {
          debugPrint('Failed to fetch products');
        }
      } catch (e) {
        debugPrint('Error fetching products');
        debugPrint('Error: $e');
      }
    }
  }
}
