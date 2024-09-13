import '../controller/categoryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/product_card.dart';
import '../../categories/widgets/category_list.dart';
import '../../../widgets/appbar_with_back_button.dart';
import '../../product/model/Product.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    // categoryController.fetchProducts(category);
    super.initState();
  }

  final controller = Get.put(CategoryController());
  final CategoryController categoryController = Get.put(CategoryController());
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(),
      body: Obx(
        () => categoryController.isLoading.value == true
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: PRIMARY_COLOR,
                      backgroundColor: Colors.black12,
                    ),
                  ],
                ), // Show loading indicator
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RefreshIndicator(
                  onRefresh: () async {},
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          //default app banner
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/defaultHomeBanner.png',
                                scale: 1,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                //Category section
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Categories",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: TITLE_COLOR,
                                        ),
                                      ),
                                      Spacer(),
                                      // TextButton(
                                      //   onPressed: () {},
                                      //   child: const Text(
                                      //     "explore >",
                                      //     style: TextStyle(
                                      //       fontSize: 18,
                                      //       fontWeight: FontWeight.w500,
                                      //       color: PRIMARY_COLOR,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const CategoryList(),
                                const SizedBox(
                                  height: 15,
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                categoryProductView(),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  //Fetch product
  Widget categoryProductView() {
    return Obx(() {
      if (categoryController.products.isNotEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryController.products.length,
          itemBuilder: (_, index) {
            Product product = categoryController.products[index];
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
