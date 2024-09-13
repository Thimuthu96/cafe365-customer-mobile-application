import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../categories/controller/categoryController.dart';
import '../controller/homeController.dart';
import 'category_list_card.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // late int activeIndex;
  List<String> categoryList = [
    'Breakfast Menu',
    'Biriyani',
    'Lunch Menu',
    'Kottu Station',
    'Soup',
    'Dessert',
    'Appetizers',
  ];

  @override
  void initState() {
    super.initState();
    // activeIndex = 0;
    categoryController
        .fetchProducts(categoryList[homeController.activeIndex.value])
        .then((value) {
      debugPrint(categoryController.products.length.toString());
    });
  }

  final CategoryController categoryController = Get.put(CategoryController());
  final HomeController homeController = Get.put(HomeController());

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: CategoryListCard(
              title: categoryList[index],
              isActive: homeController.activeIndex.value == index,
              onTapCard: () {
                setState(() {
                  homeController.activeIndex.value = index;
                  categoryController.activeIndex.value = index;
                });
                categoryController.fetchProducts(categoryList[index]);
                Navigator.pushNamed(context, "/categories");
              },
            ),
          );
        },
      ),
    );
  }
}
