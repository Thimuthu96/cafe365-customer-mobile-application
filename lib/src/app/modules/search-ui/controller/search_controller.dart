import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/consts/constants.dart';
import '../../product/model/Product.dart';

class ProductSearchController extends GetxController {
  final RxList products = <Product>[].obs;
  final RxBool isLoading = false.obs;

  // Debounce duration in milliseconds
  static const int debounceDuration = 2000;
  Timer? _debounce;

  //Get products
  Future<void> fetchProducts(String searchTitle) async {
    try {
      isLoading.value = true;
      products.clear();
      var url = Uri.parse('$BASE_URL/product-by-search/$searchTitle');
      var res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> productMap = jsonDecode(res.body);
        products
            .addAll(productMap.map((item) => Product.fromMap(item)).toList());
      }
    } catch (e) {
      debugPrint('Error fetching products');
      debugPrint('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Debounce function to delay fetching products
  void debounceFetchProducts(String searchTitle) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: debounceDuration), () {
      fetchProducts(searchTitle);
    });
  }
}
