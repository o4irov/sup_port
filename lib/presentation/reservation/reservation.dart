import 'package:booking/data/managers/reservations_managers.dart';
import 'package:booking/domain/models/reservation/reservation.dart';
import 'package:booking/presentation/common/bottom_app_bar.dart';
import 'package:booking/presentation/reservation/reservation_form.dart';
import 'package:flutter/material.dart';

class Reservations extends StatefulWidget {
  const Reservations({super.key});

  @override
  State<Reservations> createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  final ReservationsManager _reservationsManager = ReservationsManager();
  List<Reservation> _reservations = [];

  @override
  void initState() {
    _reservationsManager
        .getReservations()
        .then((value) => setState(() => _reservations = value));
    super.initState();
  }

  void change(Reservation reservation, bool? value) async {
    final newReservation = Reservation(
      id: reservation.id,
      name: reservation.name,
      phone: reservation.phone,
      date: reservation.date,
      time: reservation.time,
      isCompleted: value ?? false,
    );
    _reservations[_reservations.indexOf(
      _reservations.firstWhere((element) => element.id == reservation.id),
    )] = newReservation;
    setState(() {});
    await _reservationsManager.changeReservation(reservation: newReservation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'БРОНИРОВАНИЯ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final newReservation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReservationForm(),
                    ),
                  );
                  if (newReservation != null) {
                    setState(() {
                      _reservations.add(newReservation);
                    });
                  }
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 50)),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: ListView.builder(
          itemCount: (_reservations.length / 2).round(),
          itemBuilder: (context, idx) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      _reservations[idx * 2].name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Checkbox(
                                      value: _reservations[idx * 2].isCompleted,
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.pink),
                                      onChanged: (value) {
                                        change(_reservations[idx * 2], value);
                                      },
                                    )
                                  ],
                                ),
                                Text(
                                  _reservations[idx * 2].phone,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${(_reservations[idx * 2].date.day).toString().padLeft(2, '0')}.${(_reservations[idx * 2].date.month).toString().padLeft(2, '0')}.${_reservations[idx * 2].date.year}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${(_reservations[idx * 2].time.hour).toString().padLeft(2, '0')}:${(_reservations[idx * 2].time.minute).toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () async {
                                final newReservation = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReservationForm(
                                      reservation: _reservations[idx * 2],
                                    ),
                                  ),
                                );
                                if (newReservation != null) {
                                  if (newReservation.runtimeType == String) {
                                    setState(() {
                                      _reservations.removeWhere((element) =>
                                          element.id == newReservation);
                                    });
                                  } else {
                                    change(newReservation,
                                        newReservation.isCompleted);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 15)),
                    Flexible(
                      flex: 2,
                      child: _reservations.length > idx * 2 + 1
                          ? Stack(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            _reservations[idx * 2 + 1].name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Checkbox(
                                            value: _reservations[idx * 2 + 1]
                                                .isCompleted,
                                            fillColor: MaterialStateProperty
                                                .all<Color>(Colors.pink),
                                            onChanged: (value) async {
                                              change(_reservations[idx * 2 + 1],
                                                  value);
                                            },
                                          )
                                        ],
                                      ),
                                      Text(
                                        _reservations[idx * 2 + 1].phone,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${(_reservations[idx * 2 + 1].date.day).toString().padLeft(2, '0')}.${(_reservations[idx * 2 + 1].date.month).toString().padLeft(2, '0')}.${_reservations[idx * 2 + 1].date.year}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${(_reservations[idx * 2 + 1].time.hour).toString().padLeft(2, '0')}:${(_reservations[idx * 2 + 1].time.minute).toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.more_horiz),
                                    onPressed: () async {
                                      final newReservation =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReservationForm(
                                            reservation:
                                                _reservations[idx * 2 + 1],
                                          ),
                                        ),
                                      );
                                      if (newReservation != null) {
                                        change(newReservation,
                                            newReservation.isCompleted);
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const DemoBottomAppBar(
        activeIcon: 'reservation',
      ),
    );
  }
}
