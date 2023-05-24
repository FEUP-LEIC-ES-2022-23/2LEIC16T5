import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  const ChartsMenu({Key? key, required this.title, required this.currency})
      : super(key: key);
  final String title;
  final String currency;

  @override
  State<ChartsMenu> createState() => _ChartsMenuState();
}

class _ChartsMenuState extends State<ChartsMenu> {
  RemoteDBHelper remoteDBHelper = RemoteDBHelper(
      userInstance: FirebaseAuth.instance,
      firebaseInstance: FirebaseFirestore.instance);
  @override
  Widget build(BuildContext context) {
    List<TransactionModel> transactionList = <TransactionModel>[];
    return StreamBuilder<List<TransactionModel>>(
        stream: remoteDBHelper.readTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }
          if (snapshot.data!.isNotEmpty && snapshot.hasData) {
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
                  if (transaction.date.month == month &&
                      transaction.expense == 1 &&
                      transaction.date.year == 2023) {
                    totalExpensesForMonth += transaction.total;
                  }
                }
                expensesPerMonth[month] = totalExpensesForMonth;
              }

              List<FlSpot> spots = expensesPerMonth.entries
                  .map((entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                  .toList();
              LineChartBarData chartData = LineChartBarData(
                spots: spots,
                dotData: FlDotData(show: false),
                color: Color(entry.value.toList()[0].categoryColor!),
                // Set the properties of the line
                // In this example, the line is set to curve but stop at the x-axis
                isCurved: true,
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Center(
                  child: Text("Nothing to show",
                      style: TextStyle(fontSize: 20, color: Colors.white))),
            ],
          );
        });

  }
}
