import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secure_connect/components/common_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'plugin_view_variables.dart';

class PluginController extends GetxController with PluginVariables {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  init() async {
    await generateRandomString(6);
  }

  // Function to generate a random string with alphanumeric characters
  generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    generatedString.value = String.fromCharCodes(
      Iterable.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  /// The function retrieves the last login time of a user from Firestore and formats it to display the
  /// day name and time.
  ///
  /// Returns:
  ///   The method `getLastLogin()` returns a `Future<String>`.
  Future<String> getLastLogin() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = "";
      userId = prefs.getString("Userid").toString();
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('loginEvents')
          .orderBy('loginTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DateTime lastLoginTime =
            (querySnapshot.docs.first.data())['loginTime'].toDate();

        // Check if last login was today, yesterday, or another day
        DateTime now = DateTime.now();
        if (now.year == lastLoginTime.year &&
            now.month == lastLoginTime.month &&
            now.day == lastLoginTime.day) {
          return 'Last login at Today, ${_formatTime(lastLoginTime)}';
        } else if (now.year == lastLoginTime.year &&
            now.month == lastLoginTime.month &&
            now.day - 1 == lastLoginTime.day) {
          return 'Last login at Yesterday, ${_formatTime(lastLoginTime)}';
        } else {
          // Format to display day name
          return 'Last login at ${_formatDayName(lastLoginTime)}, ${_formatTime(lastLoginTime)}';
        }
      } else {
        return 'No previous logins';
      }
    } catch (e) {
      // Handle the exception
      return 'Error retrieving last login';
    }
  }

  String _formatTime(DateTime dateTime) {
    int hour = dateTime.hour % 12; // Convert 24-hour to 12-hour
    hour = hour == 0 ? 12 : hour; // Handle midnight (00:00) as 12 AM
    String minute = dateTime.minute
        .toString()
        .padLeft(2, '0'); // Ensure two digits for minutes
    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// The function `_formatDayName` takes a `DateTime` object as input and returns the corresponding day
  /// name as a string.
  ///
  /// Args:
  ///   dateTime (DateTime): A DateTime object representing a specific date and time.
  ///
  /// Returns:
  ///   the name of the day of the week corresponding to the given DateTime object.
  String _formatDayName(DateTime dateTime) {
    return dateTime.weekday == DateTime.monday
        ? 'Monday'
        : dateTime.weekday == DateTime.tuesday
            ? 'Tuesday'
            : dateTime.weekday == DateTime.wednesday
                ? 'Wednesday'
                : dateTime.weekday == DateTime.thursday
                    ? 'Thursday'
                    : dateTime.weekday == DateTime.friday
                        ? 'Friday'
                        : dateTime.weekday == DateTime.saturday
                            ? 'Saturday'
                            : 'Sunday';
  }

  /// The function updates the QR code image value in the most recent login document for a user in
  /// Firestore.
  ///
  /// Returns:
  ///   a `Future<void>`.
  Future<void> updateQrCodeImage() async {
    CommonWidgetFunctions.showOverlayLoader();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = "";
      userId = prefs.getString("Userid").toString();
      // Retrieve the most recent login document
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('loginEvents')
          .orderBy('loginTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the most recent document
        DocumentSnapshot<Map<String, dynamic>> recentDoc =
            querySnapshot.docs.first;

        // Check if the 'qrCodeImage' key already exists
        if (recentDoc.data()!.containsKey('qrCodeImage')) {
          // If the key exists, update its value
          await recentDoc.reference
              .update({'qrCodeImage': generatedString.value});
        } else {
          // If the key doesn't exist, add it to the document
          await recentDoc.reference.set(
              {'qrCodeImage': generatedString.value}, SetOptions(merge: true));
        }
      }
      Get.back();
    } catch (e) {
      Get.back();
      return;
    }
  }
}
