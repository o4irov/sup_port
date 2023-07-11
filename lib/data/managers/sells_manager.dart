import 'package:booking/domain/models/sell/sell.dart';
import 'package:booking/domain/models/sell/sell_isar.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'isar_getter.dart';

class SellsManager {
  Future<List<Sell>> getSells() async {
    final isar = await IsarGetter().isarGetter;
    final sells = await isar.sellIsars.where().findAll();
    return sells
        .map(
          (sell) => Sell(
            id: sell.id,
            service: sell.decode(sell.service!),
            quantity: sell.quantity!,
            date: sell.date!,
            time: TimeOfDay(
              hour: int.parse(sell.time!.substring(0, 2)),
              minute: int.parse(sell.time!.substring(3, 5)),
            ),
          ),
        )
        .toList();
  }

  Future<void> addSell({required Sell sell}) async {
    final isar = await IsarGetter().isarGetter;
    final newSell = SellIsar()
      ..id = sell.id
      ..service = sell.encode(sell.service).toString()
      ..quantity = sell.quantity
      ..date = sell.date
      ..time = sell.time.toString().substring(10, 15);
    isar.writeTxn(() async {
      await isar.sellIsars.put(newSell);
    });
  }

  Future<void> changeSell({required Sell sell}) async {
    final isar = await IsarGetter().isarGetter;
    final newSell = SellIsar()
      ..id = sell.id
      ..service = sell.encode(sell.service).toString()
      ..quantity = sell.quantity
      ..date = sell.date
      ..time = sell.time.toString().substring(10, 15);
    isar.writeTxn(() async {
      await isar.sellIsars.delete(SellIsar().fastHash(sell.id));
      await isar.sellIsars.put(newSell);
    });
  }

  Future<void> removeSell({required String id}) async {
    final isar = await IsarGetter().isarGetter;
    isar.writeTxn(() async {
      await isar.sellIsars.delete(SellIsar().fastHash(id));
    });
  }
}
