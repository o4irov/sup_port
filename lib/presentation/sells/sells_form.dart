import 'package:booking/data/managers/sells_manager.dart';
import 'package:booking/data/managers/services_manager.dart';
import 'package:booking/domain/models/sell/sell.dart';
import 'package:booking/domain/models/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

class SellsForm extends StatefulWidget {
  final Sell? sell;
  const SellsForm({super.key, this.sell});

  @override
  State<SellsForm> createState() => _SellsFormState();
}

class _SellsFormState extends State<SellsForm> {
  final ServicesManager _servicesManager = ServicesManager();
  final SellsManager _sellsManager = SellsManager();
  final TextEditingController _sumController = TextEditingController();
  late Service _service;
  int _quantity = 1;
  List<Service> _services = [];

  late final bool _isChanging;

  void getTasks() async {
    _services = await _servicesManager.getServices();
  }

  @override
  void initState() {
    getTasks();
    _service = _services.isNotEmpty
        ? _services[0]
        : Service(
            id: const Uuid().v4(),
            title: 'Выберите услугу',
            price: 0,
          );

    _isChanging = widget.sell != null;
    if (_isChanging) {
      _service = widget.sell!.service;
      _quantity = widget.sell!.quantity;
      _sumController.text = widget.sell!.sum.toString();
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
          'Форма продаж',
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
              'Услуга',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: PopupMenuButton(
                initialValue: _service.title,
                itemBuilder: (context) {
                  return _services.map((e) => item(e.title)).toList();
                },
                icon: Text(
                  _service.title,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onSelected: (value) {
                  setState(() {
                    _service = _services
                        .firstWhere((element) => element.title == value);
                  });
                },
                color: const Color.fromARGB(255, 221, 221, 221),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Количество',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                  minValue: 1,
                  maxValue: 30,
                  axis: Axis.horizontal,
                  value: _quantity,
                  onChanged: (value) => setState(() {
                    _quantity = value;
                    _sumController.text = '${_service.price * _quantity}';
                  }),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Сумма',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _sumController,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_sumController.text != '') {
                      Sell sell = Sell(
                        id: _isChanging ? widget.sell!.id : const Uuid().v4(),
                        service: _service,
                        quantity: _quantity,
                        date: _isChanging ? widget.sell!.date : DateTime.now(),
                        time: _isChanging ? widget.sell!.time : TimeOfDay.now(),
                      );
                      await _sellsManager.addSell(sell: sell);
                      Navigator.pop(context, sell);
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
                          _sellsManager.removeSell(id: widget.sell!.id);
                          Navigator.pop(context, widget.sell!.id);
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

  PopupMenuItem item(String title) {
    return PopupMenuItem(
      value: title,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
