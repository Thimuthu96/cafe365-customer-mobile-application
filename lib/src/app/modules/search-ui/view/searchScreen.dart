import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/appbar_with_back_button.dart';
import '../../../widgets/product_card.dart';
import '../../product/model/Product.dart';
import '../controller/search_Controller.dart';
import '../widgets/my_form_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final ProductSearchController searchCtrl = Get.put(ProductSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Column(
              children: [
                MyFormField(
                  enable: true,
                  isObscureText: false,
                  hint: "Search",
                  validator: (_) {},
                  controller: searchController,
                  onChange: (value) {
                    searchCtrl.products.clear();
                    debugPrint("Text changed: $value");
                    searchCtrl.debounceFetchProducts(value);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                searchResultView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Fetch product
  Widget searchResultView() {
    return Obx(() {
      if (searchCtrl.products.isNotEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: searchCtrl.products.length,
          itemBuilder: (_, index) {
            Product product = searchCtrl.products[index];
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
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No results found!",
              )
            ],
          ),
        );
      }
    });
  }
}
