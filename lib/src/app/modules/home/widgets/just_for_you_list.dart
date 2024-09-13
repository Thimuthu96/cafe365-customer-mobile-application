import '../../../widgets/appbar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/product_card.dart';
import '../../product/model/Product.dart';
import '../controller/homeController.dart';

class JustForYouList extends StatelessWidget {
  JustForYouList({super.key});

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
                Row(
                  children: const [
                    Text(
                      "Just for you",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: TITLE_COLOR,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 20),
                  child: Row(
                    children: [
                      Text(
                        "Our ${homeController.timeOfTheDay} Picks",
                        style: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w400,
                          color: TITLE_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                justForYou(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Fetch product which that suitable for time of day
  Widget justForYou(BuildContext context) {
    return Obx(() {
      if (homeController.productsOfTime.isNotEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeController.productsOfTime.length,
          itemBuilder: (_, index) {
            Product product = homeController.productsOfTime[index];
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
      } else {
        return Container();
      }
    });
  }
}
