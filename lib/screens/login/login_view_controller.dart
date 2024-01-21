import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewController extends GetxController with LoginVariables {
  final _auth = LocalAuthentication();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// The `init` function checks if a user exists and if so, performs biometric authentication.
  ///
  /// Returns:
  ///   If the response is not null, the function will return the result of the biometricAuthentication()
  /// function. If the response is null, the function will return nothing.
  init() async {
    var response = await isUserExists();
    if (response != null) {
      await biometricAuthentication();
    } else {
      return;
    }
  }

  /// The function `biometricAuthentication()` checks if biometric authentication is available, and if so,
  /// prompts the user to authenticate using biometrics before navigating to a plugin screen. If biometric
  /// authentication is not available, it displays an alert message and navigates to the plugin screen.
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

  /// The function checks if a user exists and returns the current user if they are logged in.
  ///
  /// Returns:
  ///   the current user if they exist, otherwise it returns null.
  isUserExists() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      firebaseUser = currentUser;
    }
    return currentUser;
  }

  /// The function checks if biometrics is available and supported on the device.
  ///
  /// Returns:
  ///   a `Future<bool>` value.
  Future<bool> hasBiometrics() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  /// The function `authenticate` attempts to authenticate the user using biometric authentication and
  /// returns a boolean indicating whether the authentication was successful or not.
  ///
  /// Returns:
  ///   The method is returning a `Future<bool>`.
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

  /// The function `verifyPhoneNumber` in Dart uses the `FirebaseAuth` package to verify a phone number,
  /// displaying a loading indicator while the verification process is ongoing and showing an error
  /// message if an exception occurs.
  ///
  /// Args:
  ///   phoneNumber (String): The phone number that needs to be verified. It should be in the format
  /// '+91XXXXXXXXXX' where 'XXXXXXXXXX' is the actual phone number.
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

  /// The function `verificationCompleted` handles the verification process for phone authentication in
  /// Dart, signing in the user with the provided credential and displaying a success or error message.
  ///
  /// Args:
  ///   credential (PhoneAuthCredential): The "credential" parameter is of type PhoneAuthCredential and
  /// represents the verification credential that was used to sign in the user. It contains information
  /// such as the verification ID and verification code that were used to verify the user's phone number.
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

  /// The function "verificationFailed" handles the logic for displaying an alert snackbar with an error
  /// message when a verification fails in a Dart application.
  ///
  /// Args:
  ///   e (FirebaseAuthException): The parameter "e" is of type "FirebaseAuthException" and it represents
  /// the exception that occurred during the verification process.
  void verificationFailed(FirebaseAuthException e) {
    Get.back();
    CommonWidgetFunctions.showAlertSnackbar(
        AppStrings.error,
        '${AppStrings.verificationFailed} ${e.message}',
        AppColors.redColor,
        AppColors.textColor,
        3);
  }

  /// The codeSent function sets the verificationId and displays a snackbar alert indicating that the OTP
  /// has been sent.
  ///
  /// Args:
  ///   verificationId (String): The verificationId parameter is a string that represents the unique
  /// identifier for the sent verification code. It is used to verify the user's phone number during the
  /// authentication process.
  ///   resendToken (int): The `resendToken` parameter is an optional integer value that represents a
  /// token used for resending the verification code. It can be used to resend the verification code to
  /// the user if needed.
  void codeSent(String verificationId, int? resendToken) {
    Get.back();
    this.verificationId = verificationId;
    CommonWidgetFunctions.showAlertSnackbar(AppStrings.info,
        AppStrings.otpSented, AppColors.blueDarkColor, AppColors.textColor, 3);
  }

  /// The `signInWithPhoneNumber` function handles the authentication process using a phone number and OTP
  /// (one-time password) in Dart.
  ///
  /// Args:
  ///   otp (String): The `otp` parameter is a string that represents the One-Time Password (OTP) entered
  /// by the user for phone number verification.
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
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Access the signed-in user
      User? user = authResult.user;
      // Access the UID of the user
      String uid = user?.uid ?? "";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("Userid", uid);
      await getLocation();
      await gettingIp();
      await sentDataToTheFirestore(uid);
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

  /// The function `sentDataToTheFirestore` saves user login details to a Firestore database.
  ///
  /// Args:
  ///   userUid (String): The userUid parameter is a unique identifier for the user. It is used to specify
  /// the document in the 'users' collection where the login event will be saved.
  ///
  /// Returns:
  ///   a `Future<void>`.
  Future<void> sentDataToTheFirestore(String userUid) async {
    try {
      // Generate a unique identifier for each login event using a timestamp
      String loginEventId = '${DateTime.now().millisecondsSinceEpoch}';

      // Save user details to a new document in the 'loginEvents' subcollection
      await firestore
          .collection('users')
          .doc(userUid)
          .collection('loginEvents')
          .doc(loginEventId)
          .set({
        'ipAddress': ip.value,
        'location': address.value,
        'loginTime': DateTime.now(),
      });
    } catch (e) {
      // Handle the exception
      return;
    }
  }

  /// The `getLocation` function checks if location services are enabled, requests permission if
  /// necessary, and retrieves the current position and address.
  ///
  /// Returns:
  ///   The function does not explicitly return anything. However, it updates the value of the `address`
  /// variable with the locality and country obtained from the device's current position.
  getLocation() async {
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
    } catch (e) {
      return;
    }
  }

  /// The function `gettingIp()` retrieves the IP address of the device's Wi-Fi connection and assigns it
  /// to the `ip` variable.
  gettingIp() async {
    final info = NetworkInfo();
    var hostAddress = await info.getWifiIP();
    if (hostAddress != null) {
      ip.value = hostAddress;
    }
  }
}
