import 'confiremationDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/consts/colors.dart';
import '../../core/consts/constants.dart';
import '../modules/cart/controller/cartController.dart';

class ProductCard extends StatefulWidget {
  final String productId;
  final String assetUrl;
  final String productName;
  final double productPrice;

  const ProductCard({
    super.key,
    required this.productId,
    required this.assetUrl,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final CartController cartController = Get.put(CartController());
  bool isFavourite = false;

  getLocalUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartController.userID.value = prefs.getString(UUID).toString();
  }

  @override
  void initState() {
    getLocalUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 2.5,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 4,
            blurRadius: 8,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              right: 15,
              left: 15,
              bottom: 0,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                    child: Icon(
                      Icons.favorite_border,
                      color: isFavourite ? Colors.red[400] : Colors.grey[300],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 100, // Specify the desired width
                    height: 100, // Specify the desired height
                    child: Image.network(
                      widget.assetUrl,
                      scale: 4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    //Product name
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 15),
                        child: Text(
                          widget.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    //Price     //Rating
                    Row(
                      children: [
                        Text(
                          'LKR ${widget.productPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber[400],
                            ),
                            const Text(' 4.5')
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                //Add to cart
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // addToCart();
              },
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: PRIMARY_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                    child: TextButton(
                  onPressed: () {
                    ConfirmationDialog(
                      context,
                      "Confirmation!",
                      "Are you sure want to add this item to cart?",
                      addToCart,
                    );
                    // addToCart();
                  },
                  child: const Text(
                    '+   Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ConfirmationDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirmation'),
  //         content: Text('Are you sure you want to proceed?'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context)
  //                   .pop(false); // Dismiss the dialog and return false
  //             },
  //             child: Text('No'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context)
  //                   .pop(true); // Dismiss the dialog and return true
  //             },
  //             child: Text('Yes'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  //check product of cart list
  addToCart() async {
    await cartController.addCartItems(
      context,
      cartController.userID.value,
      widget.productName,
      widget.assetUrl,
      widget.productPrice,
      widget.productId,
    );
  }
}
