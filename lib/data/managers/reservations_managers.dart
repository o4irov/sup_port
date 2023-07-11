import 'package:booking/domain/models/reservation/reservation_isar.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import '../../domain/models/reservation/reservation.dart';
import 'isar_getter.dart';

class ReservationsManager {
  Future<List<Reservation>> getReservations() async {
    final isar = await IsarGetter().isarGetter;
    final reservations = await isar.reservationIsars.where().findAll();
    return reservations
        .map(
          (reservation) => Reservation(
            id: reservation.id,
            name: reservation.name!,
            phone: reservation.phone!,
            date: reservation.date!,
            time: TimeOfDay(
              hour: int.parse(reservation.time!.substring(0, 2)),
              minute: int.parse(reservation.time!.substring(3, 5)),
            ),
            isCompleted: reservation.isCompleted!,
          ),
        )
        .toList();
  }

  Future<void> addReservation({required Reservation reservation}) async {
    final isar = await IsarGetter().isarGetter;
    final newReservation = ReservationIsar()
      ..id = reservation.id
      ..name = reservation.name
      ..phone = reservation.phone
      ..date = reservation.date
      ..time = reservation.time.toString().substring(10, 15)
      ..isCompleted = reservation.isCompleted;
    isar.writeTxn(() async {
      await isar.reservationIsars.put(newReservation);
    });
  }

  Future<void> changeReservation({required Reservation reservation}) async {
    final isar = await IsarGetter().isarGetter;
    final newReservation = ReservationIsar()
      ..id = reservation.id
      ..name = reservation.name
      ..phone = reservation.phone
      ..date = reservation.date
      ..time = reservation.time.toString().substring(10, 15)
      ..isCompleted = reservation.isCompleted;
    isar.writeTxn(() async {
      await isar.reservationIsars
          .delete(ReservationIsar().fastHash(reservation.id));
      await isar.reservationIsars.put(newReservation);
    });
  }

  Future<void> removeReservation({required String id}) async {
    final isar = await IsarGetter().isarGetter;
    isar.writeTxn(() async {
      await isar.reservationIsars.delete(ReservationIsar().fastHash(id));
    });
  }
}
