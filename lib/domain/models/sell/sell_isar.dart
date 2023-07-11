import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../service/service.dart';

part 'sell_isar.g.dart';

@Collection()
class SellIsar {
  String id = const Uuid().v4();

  Id get isarId => fastHash(id);
  String? service;
  int? quantity;
  int? sum;
  DateTime? date;
  String? time;

  int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  Service decode(String service) {
    final parameters = service.substring(1, service.length - 1).split(',');
    return Service(
      id: parameters[0].trim().split(':')[1],
      title: parameters[1].trim().split(':')[1],
      price: int.parse(parameters[2].trim().split(':')[1]),
    );
  }
}
