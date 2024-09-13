import 'package:flutter/material.dart';

import '../../../../core/consts/colors.dart';
import '../../auth/auth_middleware.dart';
import '../widgets/my_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
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
                      height: 60,
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
                                  hint: "Enter email here",
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please enter your email name';
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
                                  height: 30,
                                ),
                                MyFormField(
                                  enable: true,
                                  isObscureText: true,
                                  hint: "Enter password here",
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
                            Row(
                              children: [
                                // Column(
                                //   children: const [Text("Remember me")],
                                // ),
                                const Spacer(),
                                Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Forgot password?',
                                        style:
                                            TextStyle(color: Color(0xff1b434d)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: ElevatedButton(
                                  onPressed: () {
                                    handleLogin();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            PRIMARY_COLOR),
                                  ),
                                  child: const Text(
                                    'Sign In',
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
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.white70),
                                  ),
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: PRIMARY_COLOR,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Image.asset(
                    //     'assets/images/loginBottomDecorator.png',
                    //     fit: BoxFit.contain,
                    //     scale: 1.1,
                    //   ),
                    // ),
                  ],
                ),
              )),
            ),
    );
  }

  handleLogin() async {
    String emailHandler = emailController.text;
    String passwordHandler = pwdController.text;

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Future(() {
        AuthController.instance
            .userLogin(context, emailHandler, passwordHandler);
      });
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() => _autoValidate = AutovalidateMode.always);
    }
  }
}
