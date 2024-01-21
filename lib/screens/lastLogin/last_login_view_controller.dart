import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secure_connect/screens/lastLogin/last_login_view_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LastLoginController extends GetxController with LastLoginVariables {
  TabController? tabController;
  init() async {
    fetchData();
  }

  @override
  void onInit() {
    // tabController = TabController(length: 3, vsync: ScrollableState());
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

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

  bool _isToday(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }

  bool _isYesterday(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  // String _generateRandomString() {
  //   const String chars =
  //       'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   const int length = 6;
  //   Random random = Random();
  //   return String.fromCharCodes(
  //     Iterable.generate(
  //       length,
  //       (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  //     ),
  //   );
  // }
}
