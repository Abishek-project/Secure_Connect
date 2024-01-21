import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:secure_connect/components/common_functions.dart';
import 'package:secure_connect/constants/app_colors.dart';
import 'package:secure_connect/constants/app_paths.dart';
import 'package:secure_connect/constants/app_strings.dart';
import 'package:secure_connect/screens/login/login_view_variables.dart';

class LoginViewController extends GetxController with LoginVariables {
  final _auth = LocalAuthentication();

  void getLocation() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      permission = await Geolocator.requestPermission();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again.
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      address.value = '${place.locality},${place.country}';
      gettingIp();
    } catch (e) {
      return;
    }
  }

  void gettingIp() async {
    final info = NetworkInfo();
    var hostAddress = await info.getWifiIP();
    if (hostAddress != null) {
      ip.value = hostAddress;
    }
  }

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
        CommonWidgetFunctions.showOverlayLoader();
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
        Get.toNamed(AppPaths.plugin);
      }
    } else {
      CommonWidgetFunctions.showAlertSnackbar(
          AppStrings.noBiometric,
          AppStrings.biometricUnAvailable,
          AppColors.redColor,
          AppColors.textColor,
          3);
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
          localizedReason: AppStrings.authenticate,
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
      CommonWidgetFunctions.showAlertSnackbar(AppStrings.error,
          AppStrings.wentWrong, AppColors.redColor, AppColors.textColor, 3);
    }
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    try {
      Get.back();
      await FirebaseAuth.instance.signInWithCredential(credential);
      CommonWidgetFunctions.showAlertSnackbar(
          AppStrings.success,
          AppStrings.verificationSuccessful,
          AppColors.greenColor,
          AppColors.textColor,
          3);
    } catch (e) {
      Get.back();
      CommonWidgetFunctions.showAlertSnackbar(AppStrings.error,
          AppStrings.wentWrong, AppColors.redColor, AppColors.textColor, 3);
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    Get.back();
    CommonWidgetFunctions.showAlertSnackbar(
        AppStrings.error,
        '${AppStrings.verificationFailed} ${e.message}',
        AppColors.redColor,
        AppColors.textColor,
        3);
  }

  void codeSent(String verificationId, int? resendToken) {
    Get.back();
    this.verificationId = verificationId;
    CommonWidgetFunctions.showAlertSnackbar(AppStrings.info,
        AppStrings.otpSented, AppColors.blueDarkColor, AppColors.textColor, 3);
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
      String errorMessage = AppStrings.wentWrong;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            errorMessage = AppStrings.invalidOTP;
            break;
          case 'invalid-verification-id':
            errorMessage = AppStrings.invalidVerificationId;
            break;
          case 'session-expired':
            errorMessage = AppStrings.sessionExpired;
            break;
          default:
            errorMessage = AppStrings.authenticationFailed;
            break;
        }
      }
      CommonWidgetFunctions.showAlertSnackbar(AppStrings.error, errorMessage,
          AppColors.redColor, AppColors.textColor, 3);
    }
  }
}
