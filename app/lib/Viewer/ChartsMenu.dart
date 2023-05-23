import 'package:es/Controller/NewCategoryController.dart';
import 'package:es/Model/TransactionsModel.dart';
import 'package:es/database/RemoteDBHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../Controller/NewTransactionController.dart';
import 'package:es/Model/CategoryModel.dart' as c_model;
import 'package:es/database/LocalDBHelper.dart';

class ChartsMenu extends StatefulWidget {
  const ChartsMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ChartsMenu> createState() => _ChartsMenuState();
}

class _ChartsMenuState extends State<ChartsMenu> {
  RemoteDBHelper remoteDBHelper =
    RemoteDBHelper(userInstance: FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    List<TransactionModel> transactionList = <TransactionModel>[];
    return Scaffold(
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
            body: StreamBuilder<List<TransactionModel>>(
              stream: remoteDBHelper.readTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              'Loading...',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.white)
                          ),
                        ],
                      )
                  );
                }
                else if (!snapshot.data!.isEmpty) {
                  transactionList = snapshot.data!;
                  Map<String, List<TransactionModel>> categoryMap = {};
                  transactionList.forEach((transaction) {
                    if (categoryMap.containsKey(transaction.categoryID)) {
                      categoryMap[transaction.categoryID]!.add(transaction);
                    } else {
                      categoryMap[transaction.categoryID!] = [transaction];
                    }
                  });

                  List<LineChartBarData> chartDataList = [];
                  int i = 0;
                  categoryMap.entries.forEach((entry) {
                    Map<int, double> expensesPerMonth = {};
                    for (int month = 1; month <= 12; month++) {
                      double totalExpensesForMonth = 0;
                      for (TransactionModel transaction in entry.value) {
                        if (transaction.date.month == month && transaction.expense==1 && transaction.date.year==2023) {
                          totalExpensesForMonth += transaction.total;
                        }
                      }
                      expensesPerMonth[month] = totalExpensesForMonth;
                    }

                    List<FlSpot> spots = expensesPerMonth.entries
                        .map((entry) =>
                        FlSpot(
                            entry.key.toDouble(),
                            entry.value.toDouble()))
                        .toList();
                    LineChartBarData chartData = LineChartBarData(
                      spots: spots,
                      dotData: FlDotData(show: false),
                      color: Color(entry.value.toList()[0].categoryColor!),
                    // Set the properties of the line
                    // In this example, the line is set to curve but stop at the x-axis
                    isCurved: false,
                    curveSmoothness: 0.5,
                    preventCurveOverShooting: true,
                      // Use a different color for each line
                    );
                    chartDataList.add(chartData);
                    i++;
                  });
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: chartDataList,
                        baselineX: 0,
                        baselineY: 0,
                        minX: 1,
                        maxX: 12,
                        minY: 0,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 50,
                              getTitlesWidget: (value,titleMeta) {
                                return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                );
                              },
                            )
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            )
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            )
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value,titleMeta) {
                                switch (value.toInt()) {
                                  case 3:
                                    return Text(
                                        'MAR',
                                       style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    );
                                  case 6:
                                    return Text(
                                        'JUN',
                                        style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    );
                                  case 9:
                                    return Text(
                                        'SEP',
                                        style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    );
                                  case 12:
                                    return Text(
                                        'DEC',
                                        style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    );
                                }
                                return Text('');
                              },
                            )
                          ),
                        ),
                        backgroundColor: Colors.black26,
                        borderData: FlBorderData(
                          border: const Border(
                            bottom: BorderSide(
                              color: Colors.black54,
                              width: 5,
                            ),
                            left: BorderSide(
                              color: Colors.black54,
                              width: 5,
                            )
                          )
                        ),
                        gridData: FlGridData(
                          show: true,
                          // Customize the grid line color and thickness
                          drawVerticalLine: true,
                          verticalInterval: 1,
                          horizontalInterval: 50,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.black54,
                              strokeWidth: 1,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
                else {
                  return const CircularProgressIndicator();
                }
              }
            ));
/*  Map<String, List<TransactionModel>> categoryMap = {};
    transactionList.forEach((transaction) {
      if (categoryMap.containsKey(transaction.categoryID)) {
        categoryMap[transaction.categoryID]!.add(transaction);
      } else {
        categoryMap[transaction.categoryID!] = [transaction];
      }
    });
    categoryMap.entries.forEach((entry) {
      print("Category: ${entry.key}");
      entry.value.forEach((transaction) {
        print("  Transaction: ${transaction.name}");
      });
    });*/

    return StreamBuilder<List<TransactionModel>>(
      stream: remoteDBHelper.readTransactions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {

          return Scaffold(
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
            body: const Center(
                child: Text('Loading...',
                    style:
                    TextStyle(fontSize: 20, color: Colors.white))),
          );
        }
        if (snapshot.hasData) {
          transactionList = snapshot.data!;
          return Scaffold(
            backgroundColor: const Color.fromRGBO(20, 25, 46, 1.0),
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
            body: LineChart(
              LineChartData(
                lineBarsData: [LineChartBarData(
                    spots: transactionList.map((e) => FlSpot(e.date.month.toDouble(),e.total.toDouble())).toList(),
                    dotData: FlDotData(show: true),
                ),],
              )
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
    }
}