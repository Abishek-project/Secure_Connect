import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secure_connect/screens/lastLogin/last_login_view_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastLoginController extends GetxController with LastLoginVariables {
  init() async {
    fetchData();
  }

  /// The `fetchData` function retrieves login events from Firestore for a specific user, sorts them by
  /// login time, and categorizes them into today's data, yesterday's data, and other data.
  ///
  /// Returns:
  ///   a `Future<void>`.
  Future<void> fetchData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = "";
      userId = prefs.getString("Userid").toString();
      isLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('loginEvents')
              .get();

      querySnapshot.docs.sort((a, b) {
        var timeA = (a['loginTime'] as Timestamp).toDate();
        var timeB = (b['loginTime'] as Timestamp).toDate();
        return timeB.compareTo(timeA);
      });

      todayData.assignAll(querySnapshot.docs
          .where((doc) => _isToday(doc['loginTime'] as Timestamp))
          .map((doc) => doc.data())
          .toList());

      yesterdayData.assignAll(querySnapshot.docs
          .where((doc) => _isYesterday(doc['loginTime'] as Timestamp))
          .map((doc) => doc.data())
          .toList());

      otherData.assignAll(querySnapshot.docs
          .where((doc) =>
              !_isToday(doc['loginTime'] as Timestamp) &&
              !_isYesterday(doc['loginTime'] as Timestamp))
          .map((doc) => doc.data())
          .toList());
    } catch (e) {
      return;
    } finally {
      isLoading(false);
    }
  }

  /// The function `_isToday` checks if a given timestamp is for today's date.
  ///
  /// Args:
  ///   timestamp (Timestamp): A Timestamp object representing a specific date and time.
  ///
  /// Returns:
  ///   a boolean value.
  bool _isToday(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }

  /// The function `_isYesterday` checks if a given timestamp is from yesterday.
  ///
  /// Args:
  ///   timestamp (Timestamp): A Timestamp object representing a specific point in time.
  ///
  /// Returns:
  ///   a boolean value.
  bool _isYesterday(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }
}
