import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GeneralUtil {
  static String formatNumber(String s) =>
      NumberFormat.decimalPattern('id_ID').format(int.parse(s));
  static String get currency =>
      NumberFormat.compactSimpleCurrency(locale: 'id_ID').currencySymbol;

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p =
        0.017453292519943295; //conversion factor from radians to decimal degrees, exactly math.pi/180
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var radiusOfEarth = 6371;
    return radiusOfEarth * 2 * asin(sqrt(a));
  }

  void showSnackBarError(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBarSuccess(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String encodeId(String userId) {
// userId ini adalah usercode/username yang digunakan untuk login
// reverse userId string
    var reversedText = String.fromCharCodes(userId.runes.toList().reversed);
// convert to bytes
    List<int> byteUser = utf8.encode(reversedText);
// convert to base64
    String base64String = base64.encode(byteUser);
// url encode
    String encoded = Uri.encodeComponent(base64String);
    return encoded;
  }
}
