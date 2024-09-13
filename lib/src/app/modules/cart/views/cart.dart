import '../../biller/model/billModel.dart';
import '../controller/cartController.dart';
import '../../../../core/consts/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/confiremationDialog.dart';
import '../models/cartItemModel.dart';
import '../widgets/cartItem.dart';
import '../../../widgets/default_appbar_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../core/consts/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // late final uid;
  final CartController cartController = Get.put(CartController());
  bool isLoading = false;
  getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartController.userID.value = prefs.getString(UUID).toString();
    await cartController.getCartItems();
    await cartController.getBillAmount();
  }

  @override
  void initState() {
    getLocalUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Biller? biller =
        cartController.bill.isNotEmpty ? cartController.bill[0] : null;
    return Scaffold(
      appBar: const DefautAppBarHome(),
      body: Obx(
        () => cartController.isLoading.value == true
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
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TITLE_COLOR,
                      ),
                    ),
                    Expanded(
                      child: cartController.cartItems.length > 0
                          ? ListView.builder(
                              itemCount: cartController.cartItems.length,
                              itemBuilder: (_, index) {
                                CartItemModel cartItem =
                                    cartController.cartItems[index];

                                return CartItem(
                                  id: cartItem.id.toString(),
                                  name: cartItem.ItemName.toString(),
                                  imageUrl: cartItem.ItemImage.toString(),
                                  price:
                                      double.parse(cartItem.Price.toString()),
                                  quantity:
                                      int.parse(cartItem.Quantity.toString()),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No items found!"),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    cartController.bill.length > 0
                        ? Container(
                            decoration: BoxDecoration(color: Colors.grey[300]),
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Sub Total ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "LKR ${cartController.bill[0].SubTotal.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Discounts ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "LKR ${cartController.bill[0].discount.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Total ",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "LKR ${cartController.bill[0].Total.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                ConfirmationDialog(
                                  context,
                                  "Confirmation!",
                                  "Are you sure want continue to checkout?",
                                  () {
                                    goCheckout();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                backgroundColor: cartController
                                        .cartItems.isNotEmpty
                                    ? Colors.black
                                    : Colors
                                        .grey, // Change the button color here
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Add border radius here
                                ),
                              ),
                              child: const Text(
                                "Checkout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  goCheckout() {
    cartController.cartItems.isNotEmpty
        ? Navigator.pushNamed(context, "/add-delivery")
        : debugPrint("No items");
  }
}
