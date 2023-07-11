import 'package:booking/data/managers/isar_getter.dart';
import 'package:booking/domain/models/service/service_isar.dart';
import 'package:isar/isar.dart';

import '../../domain/models/service/service.dart';

class ServicesManager {
  Future<List<Service>> getServices() async {
    final isar = await IsarGetter().isarGetter;
    final services = await isar.serviceIsars.where().findAll();
    return services
        .map(
          (service) => Service(
            id: service.id,
            title: service.title,
            price: service.price,
          ),
        )
        .toList();
  }

  Future<void> addService({required Service service}) async {
    final isar = await IsarGetter().isarGetter;
    final newService = ServiceIsar()
      ..id = service.id
      ..title = service.title
      ..price = service.price;
    isar.writeTxn(() async {
      await isar.serviceIsars.put(newService);
    });
  }

  Future<void> changeService({required Service service}) async {
    final isar = await IsarGetter().isarGetter;
    final newService = ServiceIsar()
      ..id = service.id
      ..title = service.title
      ..title = service.title;
    isar.writeTxn(() async {
      await isar.serviceIsars.delete(ServiceIsar().fastHash(service.id));
      await isar.serviceIsars.put(newService);
    });
  }

  Future<void> removeService({required String id}) async {
    final isar = await IsarGetter().isarGetter;
    isar.writeTxn(() async {
      await isar.serviceIsars.delete(ServiceIsar().fastHash(id));
    });
  }
}
