import 'package:cloud_firestore/cloud_firestore.dart';

extension DateExtensions on int {
  int get differenceMinutesFromNow => DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this)).inMinutes;
  int get differenceDaysFromNow => DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this)).inDays;
  int get differenceMonthsFromNow => ((DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this)).inDays)/30).round();
  int get addMinutesFromNow => Timestamp.fromDate(DateTime.now().add(Duration(minutes: this))).millisecondsSinceEpoch;
  int get differenceDaysFromTimestamp => DateTime.fromMillisecondsSinceEpoch(this).difference(DateTime.now()).inDays;
}