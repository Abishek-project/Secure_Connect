import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';

mixin LoginVariables {
  String verificationId = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  RegExp regex = RegExp(r'^[6-9]\d{9}$');
  RxString address = ''.obs;
  RxString ip = ''.obs;
  User? firebaseUser;
}
