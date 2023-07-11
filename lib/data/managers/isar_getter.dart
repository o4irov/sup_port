import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/reservation/reservation_isar.dart';
import '../../domain/models/sell/sell_isar.dart';
import '../../domain/models/service/service_isar.dart';

class IsarGetter {
  Isar? isar;

  Future<Isar> get isarGetter async {
    isar = Isar.getInstance();
    final appDir = await getApplicationDocumentsDirectory();
    isar ??= await Isar.open(
      [ServiceIsarSchema, SellIsarSchema, ReservationIsarSchema],
      directory: appDir.path,
    );
    return isar!;
  }
}
