import 'package:booking/data/managers/sells_manager.dart';
import 'package:booking/presentation/common/bottom_app_bar.dart';
import 'package:booking/presentation/sells/sells_form.dart';
import 'package:booking/presentation/services/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/sell/sell.dart';

class Sells extends StatefulWidget {
  const Sells({super.key});

  @override
  State<Sells> createState() => _SellsState();
}

class _SellsState extends State<Sells> {
  final SellsManager _sellsManager = SellsManager();
  List<Sell> _sells = [];
  final List<bool> _isExpanded = [];

  String formatDate(String inputDate) {
    final parsedDate = DateFormat('dd MM yyyy').parse(inputDate);
    final formattedDate = DateFormat(
      'dd.MM.yyyy',
    ).format(parsedDate);
    return formattedDate;
  }

  @override
  void initState() {
    _sellsManager.getSells().then((value) {
      _sells = value;
      // ignore: unused_local_variable
      for (var element in _sells) {
        _isExpanded.add(false);
      }
      setState(() {});
    });
    super.initState();
  }

  void change(Sell sell) async {
    final newSell = Sell(
      id: sell.id,
      service: sell.service,
      quantity: sell.quantity,
      date: sell.date,
      time: sell.time,
    );
    _sells[_sells.indexOf(
      _sells.firstWhere((element) => element.id == sell.id),
    )] = newSell;
    setState(() {});
    await _sellsManager.changeSell(sell: newSell);
  }

  void _toggleHeight(int idx) =>
      setState(() => _isExpanded[idx] = !_isExpanded[idx]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'ПРОДАЖИ',
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
                  final newSell = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const SellsForm()),
                    ),
                  );
                  if (newSell != null) {
                    setState(() {
                      _sells.add(newSell);
                      _isExpanded.add(false);
                    });
                  }
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 20)),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Services(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.list,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: ListView.builder(
          itemCount: _sells.length,
          itemBuilder: (context, idx) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _toggleHeight(idx);
                  },
                  child: AnimatedCrossFade(
                    duration: const Duration(seconds: 1),
                    firstChild: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Услуга',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Text(
                                          _sells[idx].service.title,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Кол-во',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Text(
                                          '${_sells[idx].quantity}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Сумма',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Text(
                                          '${_sells[idx].sum} РУБ',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 15)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Flexible(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Дата',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 15)),
                                        Text(
                                          'Время',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          formatDate(
                                            '${_sells[idx].date.day} ${_sells[idx].date.month} ${_sells[idx].date.year}',
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 15)),
                                        Text(
                                          '${(_sells[idx].time.hour).toString().padLeft(2, '0')}:${(_sells[idx].time.minute).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            final newSell =
                                                await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: ((context) =>
                                                    SellsForm(
                                                      sell: _sells[idx],
                                                    )),
                                              ),
                                            );
                                            if (newSell != null) {
                                              change(newSell);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                      ],
                    ),
                    secondChild: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Услуга',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      _sells[idx].service.title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Кол-во',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      '${_sells[idx].quantity}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Сумма',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 5)),
                                    Text(
                                      '${_sells[idx].sum} РУБ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: _isExpanded[idx]
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const DemoBottomAppBar(
        activeIcon: 'sells',
      ),
    );
  }
}
