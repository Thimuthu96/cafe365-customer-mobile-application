import 'dart:async';

import 'package:cafe_365_app/src/core/consts/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(
    double amount,
    String currency,
    Function orderSave,
  ) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        amount,
        currency,
      );
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: "Cafe 365",
      ));

      //order save and get payme
      bool isSuccess = await _processPayment();
      if (isSuccess) {
        orderSave();
        debugPrint("############### Order Saved ###############");
      }
    } catch (err) {
      debugPrint('*** Something went wrong on stripe payment : $err');
    }
  }

  Future<String?> _createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      debugPrint('========');
      debugPrint(_calculateAmount(amount));
      debugPrint('========');

      //response
      var res = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $STRIPE_SECRET_KEY",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (res.data != null) {
        // debugPrint('#########');
        // debugPrint(res.data.toString());
        // debugPrint('#########');
        return res.data["client_secret"];
      }
      return null;
    } catch (err) {
      debugPrint('*** Something went wrong on create stripe payment : $err');
    }
    return null;
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (err) {
      debugPrint('*** Something went wrong on process stripe payment : $err');
      return false;
    }
  }

  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).toInt();
    return calculatedAmount.toString();
  }
}
