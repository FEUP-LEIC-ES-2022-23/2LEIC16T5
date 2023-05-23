import 'package:es/Viewer/ChartsMenu.dart';
import 'package:es/Viewer/StatisticsMenu.dart';
import 'package:flutter/material.dart';

class SwipableCharts extends StatefulWidget {
  const SwipableCharts(
      {super.key, required this.title, required this.currency});
  final String currency;
  final String title;

  @override
  State<SwipableCharts> createState() => SwipableChartsState();
}

class SwipableChartsState extends State<SwipableCharts> {
  bool swipped = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (details) {
        if (details.delta.dx < 0) {
          setState(() {
            swipped = true;
          });
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title,
                style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          backgroundColor: const Color.fromRGBO(20, 25, 46, 1.0),
          body: PageView(
            scrollDirection: Axis.horizontal,
            children: [
              swipped
                  ? StatiscticsMenu(
                      title: 'Statistics',
                      currency: widget.currency,
                      swipped: true)
                  : StatiscticsMenu(
                      title: 'statistics',
                      currency: widget.currency,
                      swipped: false),
              const ChartsMenu(title: 'Charts')
            ],
          )),
    );
  }
}
