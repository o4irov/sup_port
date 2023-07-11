import 'package:flutter/material.dart';

import '../service/service.dart';

class Sell {
  String id;
  Service service;
  int quantity;
  int sum;
  DateTime date;
  TimeOfDay time;

  Sell({
    required this.id,
    required this.service,
    required this.quantity,
    required this.date,
    required this.time,
  }) : sum = service.price * quantity;

  Map<String, dynamic> encode(Service service) {
    return {
      'id': service.id,
      'title': service.title,
      'price': service.price,
    };
  }
}
