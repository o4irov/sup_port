import 'package:booking/data/managers/reservations_managers.dart';
import 'package:booking/domain/models/reservation/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ReservationForm extends StatefulWidget {
  final Reservation? reservation;
  const ReservationForm({super.key, this.reservation});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final ReservationsManager _reservationsManager = ReservationsManager();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isProvided = false;

  late final bool _isChanging;

  String formatDate(String inputDate) {
    final parsedDate = DateFormat('dd MM yyyy').parse(inputDate);
    final formattedDate = DateFormat(
      'dd.MM.yyyy',
    ).format(parsedDate);
    return formattedDate;
  }

  @override
  void initState() {
    _isChanging = widget.reservation != null;
    if (_isChanging) {
      _nameController.text = widget.reservation!.name;
      _phoneController.text = widget.reservation!.phone;
      _selectedDate = widget.reservation!.date;
      _selectedTime = widget.reservation!.time;
      _isProvided = widget.reservation!.isCompleted;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Форма бронирования',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 50)),
            const Text(
              'Имя',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Телефон',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Дата',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                formatDate(
                    '${_selectedDate.day} ${_selectedDate.month} ${_selectedDate.year}'),
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.pink,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Время',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                '${(_selectedTime.hour).toString().padLeft(2, '0')}:${(_selectedTime.minute).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.pink,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Услуга оказана',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            Checkbox(
              value: _isProvided,
              onChanged: (value) => setState(() => _isProvided = !_isProvided),
              fillColor: MaterialStateProperty.all<Color>(Colors.pink),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_nameController.text != '' &&
                        _phoneController.text != '') {
                      Reservation reservation = Reservation(
                        id: _isChanging
                            ? widget.reservation!.id
                            : const Uuid().v4(),
                        name: _nameController.text,
                        phone: _phoneController.text,
                        date: _selectedDate,
                        time: _selectedTime,
                        isCompleted: _isProvided,
                      );
                      await _reservationsManager.addReservation(
                          reservation: reservation);
                      Navigator.pop(context, reservation);
                    }
                  },
                  child: Container(
                    width: 230,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Text(
                        'СОХРАНИТЬ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _isChanging
                      ? () async {
                          await _reservationsManager.removeReservation(
                              id: widget.reservation!.id);
                          Navigator.pop(context, widget.reservation!.id);
                        }
                      : null,
                  child: Container(
                    width: 230,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: _isChanging
                          ? const Color.fromRGBO(222, 0, 0, 1)
                          : const Color.fromRGBO(222, 0, 0, 0.694),
                    ),
                    child: const Center(
                      child: Text(
                        'УДАЛИТЬ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            cardColor: Colors.pink,
            primaryColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
