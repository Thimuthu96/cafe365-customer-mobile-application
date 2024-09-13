import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/appbar_with_back_button.dart';
import '../../../widgets/product_card.dart';
import '../../product/model/Product.dart';
import '../controller/homeController.dart';

class TrendingList extends StatelessWidget {
  TrendingList({super.key});

  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Column(
              children: [
                homeController.products.isNotEmpty
                    ? const Row(
                        children: [
                          Text(
                            "Today hot selling",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: TITLE_COLOR,
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        children: [
                          Text(
                            "Alltime popular",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: TITLE_COLOR,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                hotsellingProducts(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //hot selling products
  Widget hotsellingProducts(BuildContext context) {
    return Obx(() {
      if (homeController.products.isEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeController.productList.length,
          itemBuilder: (BuildContext context, int index) {
            Product product = homeController.productList[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ProductCard(
                productId: product.Id.toString(),
                productName: product.ItemName.toString(),
                productPrice: double.parse(product.Price.toString()),
                assetUrl: product.ItemImage.toString(),
              ),
            );
          },
        );
        // return const Center(
        //   child: Text('No data found!'),
        // );
      } else {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeController.products.length,
          itemBuilder: (BuildContext context, int index) {
            Product product = homeController.products[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ProductCard(
                productId: product.Id.toString(),
                productName: product.ItemName.toString(),
                productPrice: double.parse(product.Price.toString()),
                assetUrl: product.ItemImage.toString(),
              ),
            );
          },
        );
      }
    });
  }
}
