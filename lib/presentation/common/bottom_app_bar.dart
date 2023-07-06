import 'package:booking/presentation/reservation/reservation.dart';
import 'package:booking/presentation/sells/sells.dart';
import 'package:flutter/material.dart';

class DemoBottomAppBar extends StatelessWidget {
  const DemoBottomAppBar({
    super.key,
    this.activeIcon = 'reservation',
  });

  final String activeIcon;

  @override
  Widget build(BuildContext context) {
    const hidden = Color.fromRGBO(1, 1, 1, 0);

    return SizedBox(
      height: 94,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            height: 68,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 3,
                      width: 45,
                      child: Container(
                        color:
                            activeIcon == 'reservation' ? Colors.white : hidden,
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      icon: const Icon(
                        Icons.assignment_rounded,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: activeIcon == 'reservation'
                          ? null
                          : () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Reservation()),
                                (route) => false,
                              );
                            },
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 3,
                      width: 45,
                      child: Container(
                        color: activeIcon == 'sells' ? Colors.white : hidden,
                      ),
                    ),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      icon: const Icon(
                        Icons.sell_rounded,
                        color: Colors.white,
                        size: 45,
                      ),
                      onPressed: activeIcon == 'sells'
                          ? null
                          : () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Sells()),
                                (route) => false,
                              );
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
