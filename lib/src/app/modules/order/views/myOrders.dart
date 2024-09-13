import '../models/orderData.dart';
import '../widgets/order-card.dart';
import '../../../widgets/appbar_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/consts/constants.dart';
import '../controller/orderCtrl.dart';

class MyOrders extends StatefulWidget {
  MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    fetchMyOrders();
    super.initState();
  }

  fetchMyOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uuid = (prefs.getString(UUID))?.replaceAll('"', '');
    await orderController.fetchMyOrders(uuid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("My Orders"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: myOrders(),
                ),
                // MyOrders(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Fetch my orders
  Widget myOrders() {
    return Obx(() {
      if (orderController.orders.isNotEmpty) {
        return ListView.builder(
          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 1,
          // ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: orderController.orders.length,
          itemBuilder: (_, index) {
            OrderData order = orderController.orders[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: OrderCard(
                orderId: order.OrderId.toString(),
                orderPrice: order.Price.toString(),
                orderStatus: order.State.toString(),
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
