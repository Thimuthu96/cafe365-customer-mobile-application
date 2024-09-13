import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../product/model/Product.dart';
import '../../../../core/consts/constants.dart';

class CategoryController extends GetxController {
  final RxList products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt activeIndex = 0.obs;

  //Get products
  Future<void> fetchProducts(String category) async {
    try {
      isLoading.value = true;
      products.clear();
      var url = Uri.parse('$BASE_URL/product-by-category/$category');
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
}
