import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/consts/colors.dart';
import '../../../widgets/appbar_with_back_button.dart';
import '../../cart/controller/cartController.dart';
import '../controller/checkoutController.dart';
import '../models/checkoutModel.dart';
import '../widgets/my_form_field.dart';

class AddDelivery extends StatefulWidget {
  AddDelivery({super.key});

  @override
  State<AddDelivery> createState() => _AddDeliveryState();
}

class _AddDeliveryState extends State<AddDelivery> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController townController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  final CheckOutController checkOutController = Get.put(CheckOutController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    MyFormField(
                      enable: true,
                      isObscureText: false,
                      hint: "Your name",
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.grey[500],
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormField(
                      enable: true,
                      isObscureText: false,
                      hint: "Mobile",
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (text.length < 10 || text.length > 10) {
                          return 'Please enter valid mobile number';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                      icon: Icon(
                        Icons.phone_android,
                        color: Colors.grey[500],
                      ),
                      controller: mobileController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormField(
                      enable: true,
                      isObscureText: false,
                      hint: "House/Street",
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter your house address';
                        }
                        return null;
                      },
                      icon: Icon(
                        Icons.location_city,
                        color: Colors.grey[500],
                      ),
                      controller: streetAddressController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyFormField(
                      enable: true,
                      isObscureText: false,
                      hint: "Town",
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please enter your town';
                        }
                        return null;
                      },
                      icon: Icon(
                        Icons.location_city,
                        color: Colors.grey[500],
                      ),
                      controller: townController,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton(
                      onPressed: () {
                        handleAddDelivery();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 235, 235, 235)),
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleAddDelivery() async {
    String nameHandler = nameController.text;
    String mobileNumberHandler = mobileController.text;
    String streetAddressHandler = streetAddressController.text;
    String townHandler = townController.text;

    if (_formKey.currentState!.validate()) {
      String Id = cartController.userID.toString();
      String uuid = Id.replaceAll('"', '');
      await checkOutController.addCheckoutInfo(
          context,
          CheckOutModel(
            UserId: uuid,
            Name: nameHandler,
            Mobile: mobileNumberHandler,
            HouseAddress: streetAddressHandler,
            Town: townHandler,
          ));
      Navigator.pushNamed(context, "/payment-option");
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }
}
