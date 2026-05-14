import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppFormatter {

  static String formatFlightDate(DateTime date) {

    return DateFormat(
      'EEE, d MMM',
    ).format(date);

  }

  String removeSpace(TextEditingController value){
    return value.text.trim();
  }

  static String formatTime(String time) {

    try {

      final parts = time.split(":");

      return "${parts[0]}:${parts[1]}";

    } catch (e) {

      return time;
    }
  }
}