import 'package:flutter/material.dart';

class Reservation {
  String id;
  String name;
  String phone;
  DateTime date;
  TimeOfDay time;
  bool isCompleted;

  Reservation({
    required this.id,
    required this.name,
    required this.phone,
    required this.date,
    required this.time,
    required this.isCompleted,
  });
}
