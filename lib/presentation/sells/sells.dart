import 'package:booking/presentation/common/bottom_app_bar.dart';
import 'package:booking/presentation/services/services.dart';
import 'package:flutter/material.dart';

class Sells extends StatefulWidget {
  const Sells({super.key});

  @override
  State<Sells> createState() => _SellsState();
}

class _SellsState extends State<Sells> {
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
                onPressed: () {},
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
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, idx) {
          return Container();
        },
      ),
      bottomNavigationBar: const DemoBottomAppBar(
        activeIcon: 'sells',
      ),
    );
  }
}
