import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/consts/colors.dart';
import '../controller/user_controller.dart';
import '../widgets/my_form_field.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  final UserController userController = Get.put(UserController());

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
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
          : SingleChildScrollView(
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/loginLogo.png',
                      fit: BoxFit.contain,
                      scale: 0.8,
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate,
                        child: Column(
                          children: [
                            Column(
                              children: [
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
                                    } else if (text.length < 10 ||
                                        text.length > 10) {
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
                                  hint: "City",
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter your city';
                                    }
                                    return null;
                                  },
                                  icon: Icon(
                                    Icons.location_city,
                                    color: Colors.grey[500],
                                  ),
                                  controller: cityController,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MyFormField(
                                  enable: true,
                                  isObscureText: false,
                                  hint: "Your email",
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.grey[500],
                                  ),
                                  controller: emailController,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MyFormField(
                                  enable: true,
                                  isObscureText: true,
                                  hint: "Enter password",
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  icon: Icon(
                                    Icons.password,
                                    color: Colors.grey[500],
                                  ),
                                  controller: pwdController,
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
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                  onPressed: () {
                                    handleSignUp();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            PRIMARY_COLOR),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white70),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: PRIMARY_COLOR,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
    );
  }

  handleSignUp() async {
    String nameHandler = nameController.text;
    String mobileNumberHandler = mobileController.text;
    String cityHandler = cityController.text;
    String emailHandler = emailController.text;
    String passwordHandler = pwdController.text;

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await userController.addUser(
          context,
          User(
            name: nameHandler,
            mobile: mobileNumberHandler,
            city: cityHandler,
            email: emailHandler,
            password: passwordHandler,
          ));

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }
}
