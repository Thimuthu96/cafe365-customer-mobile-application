import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/confiremationDialog.dart';
import '../controller/cartController.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  // final Function(int) onQuantityChanged;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    // required this.onQuantityChanged,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  final CartController cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                widget.imageUrl,
                scale: 1,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: TITLE_COLOR,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.price.toString(),
                  style: const TextStyle(
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  color: widget.quantity == 1 ? Colors.grey : Colors.black,
                  icon: const Icon(Icons.remove),
                  onPressed: () => itemDecrease(),
                ),
                Text(widget.quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => itemIncrease(),
                ),
              ],
            ),
            IconButton(
              onPressed: () => ConfirmationDialog(
                context,
                "Confirmation!",
                "Are you sure want to remove this item from cart?",
                itemDelete,
              ),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  //increase
  itemIncrease() async {
    int qnt = widget.quantity + 1;
    await cartController.updateCartItem(widget.id, qnt);
    await cartController.getBillAmount();
  }

  //decrease
  itemDecrease() async {
    if (widget.quantity > 1) {
      int qnt = widget.quantity - 1;
      await cartController.updateCartItem(widget.id, qnt);
      await cartController.getBillAmount();
    }
  }

  //remove item from list
  itemDelete() async {
    await cartController.deleteCartItem(widget.id);
    await cartController.getBillAmount();
  }
}
