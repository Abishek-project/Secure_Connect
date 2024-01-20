import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_connect/constants/app_paths.dart';
import 'package:secure_connect/screens/login/login_view_variables.dart';

class LoginViewController extends GetxController with LoginVariables {
  final _auth = LocalAuthentication();

  init() async {
    var response = await isUserExists();
    if (response != null) {
      await biometricAuthentication();
    } else {
      return;
    }
  }

  biometricAuthentication() async {
    bool isBiometricAvailable = await hasBiometrics();
    if (isBiometricAvailable) {
      bool isAuthenticate = await authenticate();
      if (isAuthenticate) {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false,
        );
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
        Get.toNamed(AppPaths.plugin);
      }
    } else {
      Get.snackbar(
        'No Biometric',
        'Biometric authentication unavailable.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
      );
      Get.toNamed(AppPaths.plugin);
    }
  }

  isUserExists() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser;
  }

  Future<bool> hasBiometrics() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
          localizedReason: 'Authenticate',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: true));
    } catch (e) {
      return false;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
      );
    }
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    try {
      Get.back();
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.snackbar(
        'Success',
        'Phone number verification successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
      );
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    Get.back();
    Get.snackbar(
      'Error',
      'Phone number verification failed. ${e.message}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
    );
  }

  void codeSent(String verificationId, int? resendToken) {
    Get.back();
    this.verificationId = verificationId;
    Get.snackbar(
      'Info',
      'OTP has been sent to your phone.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
    );
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    // Get.back();
    // Get.snackbar(
    //   'Info',
    //   'Automatic OTP retrieval timed out. Please enter the OTP manually.',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.blue,
    //   colorText: Colors.white,
    //   snackStyle: SnackStyle.FLOATING,
    //   duration: const Duration(seconds: 3),
    //   margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
    // );
  }

  Future<void> signInWithPhoneNumber(String otp) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      phoneNumberController.clear();
      otpController.clear();
      Get.back();
      Get.toNamed(AppPaths.plugin);
    } catch (e) {
      Get.back();
      String errorMessage = 'Something went wrong';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            errorMessage = 'Invalid OTP. Please enter the correct code.';
            break;
          case 'invalid-verification-id':
            errorMessage = 'Invalid verification ID. Please try again.';
            break;
          case 'session-expired':
            errorMessage =
                'Verification session has expired. Please try again.';
            break;
          default:
            errorMessage = 'Authentication failed. Please try again.';
            break;
        }
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.only(bottom: 30, right: 15, left: 15),
      );
    }
  }
}
