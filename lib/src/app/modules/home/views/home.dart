import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/consts/colors.dart';
import '../../../../core/consts/constants.dart';
import '../../../widgets/default_appbar_home.dart';
import '../../../widgets/product_card.dart';
import '../../cart/controller/cartController.dart';
import '../../order/controller/orderCtrl.dart';
import '../../product/model/Product.dart';
import '../../register/controller/user_controller.dart';
import '../controller/homeController.dart';
import '../widgets/category_list.dart';
import '../../../widgets/dashed_divider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartController.userID.value = prefs.getString(UUID).toString();
  }

  @override
  void initState() {
    homeController.fetchHotSellingItems();
    homeController.fetchAllTimePopularItems();
    homeController.fetchProductForTime();
    getLocalUser();
    getInfo();

    super.initState();
  }

  final controller = Get.put(HomeController());
  final HomeController homeController = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  final UserController userController = Get.put(UserController());
  final OrderController orderController = Get.put(OrderController());
  bool isLoading = false;

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userController.userName.value = prefs.getString(USER_NAME) ?? "";
    String? uuid = (prefs.getString(UUID))?.replaceAll('"', '');
    //get loyalty points
    await userController.fetchUserLoyaltyPoints(context, uuid);
    await orderController.fetchMyOrders(uuid.toString());
    await userController.fetchUserLoyaltyPoints(context, uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefautAppBarHome(),
      body: Obx(() => homeController.isLoading.value == true ||
              cartController.isLoading.value == true
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25,
                          ),
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/DefaultHomeBackground.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Column(
                              children: [
                                //name with level
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Good ${homeController.timeOfTheDay},',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${userController.userName.value.toString()}!',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Text(
                                        'Level 1',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                //divider
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: DashedDivider(color: Colors.white),
                                ),
                                //points
                                Center(
                                  child: Text(
                                    '${userController.userPoints.value} Points',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
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
                                child: Row(
                                  children: [
                                    const Text(
                                      "Categories",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: TITLE_COLOR,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, "/categories");
                                      },
                                      child: const Text(
                                        "explore >",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const CategoryList(),
                              const SizedBox(
                                height: 15,
                              ),

                              //Special offers
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width,
                              //   child: ClipRRect(
                              //     borderRadius: BorderRadius.circular(8),
                              //     child: Image.asset(
                              //       'assets/images/bigTasetADD.png',
                              //       scale: 1,
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),

                              // const SizedBox(
                              //   height: 5,
                              // ),
                              //Hot selling items section
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    homeController.products.isNotEmpty
                                        ? Row(
                                            children: [
                                              const Text(
                                                "Today hot selling",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: TITLE_COLOR,
                                                ),
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      "/trending-list");
                                                },
                                                child: const Text(
                                                  "explore >",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: PRIMARY_COLOR,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              const Text(
                                                "Alltime popular",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: TITLE_COLOR,
                                                ),
                                              ),
                                              const Spacer(),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      "/trending-list");
                                                },
                                                child: const Text(
                                                  "explore >",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: PRIMARY_COLOR,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              hotsellingProducts(),
                              const SizedBox(
                                height: 15,
                              ),

                              //App banners
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.25,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/appBanner1.jpg',
                                          scale: 1,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.25,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/appBanner2.jpg',
                                          scale: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              //Just for you items section
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Just for you",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: TITLE_COLOR,
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "/justForYou-list");
                                          },
                                          child: const Text(
                                            "explore >",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: PRIMARY_COLOR,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 20),
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
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),
                              justForYou(),
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
            )),
    );
  }

  //get current date
  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  //hot selling products
  Widget hotsellingProducts() {
    return Obx(() {
      if (homeController.products.isEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeController.productList.length > 4
              ? 4
              : homeController.productList.length,
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

  //Fetch product which that suitable for time of day
  Widget justForYou() {
    return Obx(() {
      if (homeController.productsOfTime.isNotEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width / 560,
            crossAxisCount: 2,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: homeController.productsOfTime.length > 6
              ? 6
              : homeController.productsOfTime.length,
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
