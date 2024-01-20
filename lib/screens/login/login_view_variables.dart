import 'package:flutter/material.dart';

mixin LoginVariables {
  String verificationId = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  RegExp regex = RegExp(r'^[6-9]\d{9}$');
}
