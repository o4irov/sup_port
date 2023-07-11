import 'package:booking/data/managers/services_manager.dart';
import 'package:booking/presentation/services/services_form.dart';
import 'package:flutter/material.dart';

import '../../domain/models/service/service.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<Service> _services = [];
  final ServicesManager _servicesManager = ServicesManager();

  @override
  void initState() {
    _servicesManager
        .getServices()
        .then((value) => setState(() => _services = value));
    super.initState();
  }

  void change(Service service) async {
    final newService = Service(
      id: service.id,
      title: service.title,
      price: service.price,
    );
    _services[_services.indexOf(
      _services.firstWhere((element) => element.id == service.id),
    )] = newService;
    setState(() {});
    await _servicesManager.changeService(service: newService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text(
          'УСЛУГИ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.left,
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final newService = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const ServicesForm()),
                    ),
                  );
                  if (newService != null) {
                    setState(() {
                      _services.add(newService);
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
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
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
          itemCount: _services.length,
          itemBuilder: (context, idx) {
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 130,
                              child: Column(
                                children: [
                                  const Text(
                                    'Услуга',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _services[idx].title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Стоимость',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${_services[idx].price} РУБ',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 2,
                        child: IconButton(
                          onPressed: () async {
                            final newService = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => ServicesForm(
                                      service: _services[idx],
                                    )),
                              ),
                            );
                            if (newService != null) {
                              setState(() {
                                if (newService.runtimeType == String) {
                                  _services.removeWhere(
                                      (element) => element.id == newService);
                                } else {
                                  change(newService);
                                }
                              });
                            }
                          },
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
              ],
            );
          },
        ),
      ),
    );
  }
}
