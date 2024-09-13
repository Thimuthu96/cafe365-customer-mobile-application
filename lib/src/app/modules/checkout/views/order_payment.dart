// ignore_for_file: invalid_return_type_for_catch_error

import 'package:cafe_365_app/src/app/modules/checkout/controller/checkoutController.dart';
import 'package:cafe_365_app/src/app/modules/order/controller/orderCtrl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/consts/colors.dart';
import '../../../../core/consts/constants.dart';
import '../../../../core/services/stripe_service.dart';
import '../../../widgets/appbar_with_back_button.dart';
import '../../../widgets/confiremationDialog.dart';
import '../../cart/controller/cartController.dart';
import '../widgets/payment_method_widget.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CartController cartController = Get.put(CartController());
  final CheckOutController checkOutController = Get.put(CheckOutController());
  final OrderController orderController = Get.put(OrderController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  int _selectedPaymentMethod = 0; // 0 = Stripe, 1 = Cash on Delivery
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Place your order",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TITLE_COLOR),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
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
                                width: MediaQuery.of(context).size.width / 5,
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
                                width: MediaQuery.of(context).size.width / 5,
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
                                width: MediaQuery.of(context).size.width / 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      "Payment options",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TITLE_COLOR),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    PaymentMethodWidget(
                      title: 'Stripe',
                      isActive: _selectedPaymentMethod == 0,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodWidget(
                      title: 'Cash on Delivery',
                      isActive: _selectedPaymentMethod == 1,
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FloatingActionButton.extended(
            onPressed: () {
              ConfirmationDialog(
                  context,
                  "Confirmation!",
                  _selectedPaymentMethod == 0
                      ? "Are you sure want to continue and place the order using stripe?"
                      : "Are you sure want to continue and place the order using cash on delivery?",
                  _selectedPaymentMethod == 0
                      ? () {
                          StripeService.instance.makePayment(
                              double.parse(cartController.bill[0].Total),
                              "usd",
                              stripeOrderSave);
                        }
                      : () {
                          codOrderSave();
                        }
                  // orderSave,
                  );
            },
            label: const Text(
              "Proceed",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            backgroundColor: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }

  stripeOrderSave() async {
    final _db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = cartController.userID.value;
    String uuid = Id.replaceAll('"', '');

    String checkoutId = prefs.getString(CHECKOUT_ID).toString();
    String email = prefs.getString(EMAIL).toString();
    String userName = prefs.getString(USER_NAME).toString();
    String orderId = checkoutId.replaceAll('"', '');
    String emailId = email.replaceAll('"', '');
    String uName = userName.replaceAll('"', '');

    //Date
    var today = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(today).toString();

    //Time
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);

    var dataJson = {
      "OrderId": orderId,
      "Price": cartController.bill[0].Total.toString(),
      "State": "WAITING",
      "Table": "Take-Away",
      "Date": formattedDate,
      "Time": formattedTime,
      "uuid": uuid,
      "Details":
          cartController.cartItems.map((element) => element.toMap()).toList(),
      "remark": "N/A",
      "isMobile": true,
      "paymentMethod": "Stripe",
      "emailId": emailId,
    };
    try {
      cartController.isLoading.value = true;
      await _db.collection("order").add(dataJson).whenComplete(() async {
        await createFastMovingItems(
            cartController.cartItems.map((element) => element.toMap()).toList(),
            formattedDate);
        //update loyalty points
        double points = double.parse(cartController.bill[0].Total) * 3 / 100;
        await checkOutController.updateLoyaltyPoints(
            uuid, points.toStringAsFixed(2));
        cartController.isLoading.value = false;
        Navigator.pushNamed(context, "/order-success");
        Get.snackbar(
          'Success',
          'Success message',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          titleText: const Text(
            'Success!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          messageText: const Text(
            'Your order received!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      });

      //Order success mail sent
      orderController.sendOrderSuccessMail(emailId, uName, orderId,
          formattedDate, cartController.bill[0].Total.toString());

      //clean cart items
      await cartController.cartClean(uuid).then((value) {
        //   Get.snackbar(
        //     'Success',
        //     'Success message',
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.green,
        //     titleText: const Text(
        //       'Success!',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //     messageText: const Text(
        //       'Your order received!',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   );
        // });
      }).catchError(
        (err, StackTrace) {
          cartController.isLoading.value = false;
          Get.snackbar(
            'Error',
            'Something went wrong',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            titleText: const Text(
              'Error!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            messageText: const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
          debugPrint(err.toString());
          return Future<void>.error(
              err); // Return a Future<void> with the error
        },
      );
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }

  codOrderSave() async {
    final _db = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String Id = cartController.userID.value;
    String uuid = Id.replaceAll('"', '');

    String checkoutId = prefs.getString(CHECKOUT_ID).toString();
    String email = prefs.getString(EMAIL).toString();
    String userName = prefs.getString(USER_NAME).toString();
    String orderId = checkoutId.replaceAll('"', '');
    String emailId = email.replaceAll('"', '');
    String uName = userName.replaceAll('"', '');

    //Date
    var today = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(today).toString();

    //Time
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);

    var dataJson = {
      "OrderId": orderId,
      "Price": cartController.bill[0].Total.toString(),
      "State": "WAITING",
      "Table": "Take-Away",
      "Date": formattedDate,
      "Time": formattedTime,
      "uuid": uuid,
      "Details":
          cartController.cartItems.map((element) => element.toMap()).toList(),
      "remark": "N/A",
      "isMobile": true,
      "paymentMethod": "cod",
      "emailId": emailId,
    };
    try {
      cartController.isLoading.value = true;
      await _db.collection("order").add(dataJson).whenComplete(() async {
        await createFastMovingItems(
            cartController.cartItems.map((element) => element.toMap()).toList(),
            formattedDate);
        //update loyalty points
        double points = double.parse(cartController.bill[0].Total) * 3 / 100;
        await checkOutController.updateLoyaltyPoints(
            uuid, points.toStringAsFixed(2));
        cartController.isLoading.value = false;
        Navigator.pushNamed(context, "/order-success");
        Get.snackbar(
          'Success',
          'Success message',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          titleText: const Text(
            'Success!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          messageText: const Text(
            'Your order received!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      });

      //Order success mail sent
      orderController.sendOrderSuccessMail(emailId, uName, orderId,
          formattedDate, cartController.bill[0].Total.toString());

      //clean cart items
      await cartController.cartClean(uuid).then((value) {
        //   Get.snackbar(
        //     'Success',
        //     'Success message',
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.green,
        //     titleText: const Text(
        //       'Success!',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //     messageText: const Text(
        //       'Your order received!',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   );
        // });
      }).catchError(
        (err, StackTrace) {
          cartController.isLoading.value = false;
          Get.snackbar(
            'Error',
            'Something went wrong',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            titleText: const Text(
              'Error!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            messageText: const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
          debugPrint(err.toString());
          return Future<void>.error(
              err); // Return a Future<void> with the error
        },
      );
    } catch (err) {
      debugPrint('***********');
      debugPrint('Something went wrong $err');
      debugPrint('***********');
    }
  }

  Future<void> createFastMovingItems(List<dynamic> details, String date) async {
    final _db = FirebaseFirestore.instance;
    try {
      final items =
          details.map((item) => item['Id'] ?? item['ItemId']).toList();

      await _db.collection("fast-moving-items").add({
        "Date": date,
        "Items": items,
      });
    } catch (err) {
      debugPrint('Error creating fast-moving items: $err');
    }
  }
}
