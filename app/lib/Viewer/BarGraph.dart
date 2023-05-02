import 'package:es/Model/BudgetBarModel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  const MyBarGraph(
      {super.key,
      required this.barsData,
      required this.barWidth,
      required this.graphMaxY,
      required this.spaceBetweenBars,
      required this.graphContainerHeight});
  final List<BudgetBarModel> barsData;
  final double graphContainerHeight;
  final double barWidth;
  final double spaceBetweenBars;
  final double graphMaxY;

  @override
  State<MyBarGraph> createState() => BarGraphState();
}

class BarGraphState extends State<MyBarGraph> {
  bool barTouched = false;

  @override
  Widget build(BuildContext context) {
    double totalWidth = widget.barsData.length *
                (widget.barWidth + widget.spaceBetweenBars) >
            MediaQuery.of(context).size.width
        ? widget.barsData.length * (widget.barWidth + widget.spaceBetweenBars)
        : MediaQuery.of(context).size.width;
    double spaceBetweenBars =
        (totalWidth - (widget.barWidth * widget.barsData.length)) /
            (widget.barsData.length - 1);

    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            color: Colors.black,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: widget.graphContainerHeight,
                width: totalWidth,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      maxY: widget.graphMaxY,
                      groupsSpace: widget.spaceBetweenBars,
                      barTouchData: BarTouchData(
                          enabled: true,
                          touchCallback: (p0, p1) {
                            if (mounted) {
                              setState(() {
                                barTouched = p0.isInterestedForInteractions;
                              });
                            }
                          },
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.white,
                            direction: TooltipDirection.auto,
                            tooltipMargin: -10,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                  'Limit: ',
                                  TextStyle(
                                      color: Color(
                                          widget.barsData[group.x].color!),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  children: [
                                    TextSpan(
                                        text: widget.barsData[group.x!].limit
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(widget
                                                .barsData[group.x].color!),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: 'Value: ',
                                        style: TextStyle(
                                            color: Color(widget
                                                .barsData[group.x].color!),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: widget.barsData[group.x!].value
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(widget
                                                .barsData[group.x].color!),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ]);
                            },
                          )),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(
                              drawBehindEverything: true,
                              sideTitles: SideTitles(
                                  showTitles: false,
                                  reservedSize: 30,
                                  getTitlesWidget: getTopTilesStatus)),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: getBottomTiles))),
                      barGroups: widget.barsData
                          .map((budgetBarData) =>
                              BarChartGroupData(x: budgetBarData.x!, barRods: [
                                BarChartRodData(
                                    toY: budgetBarData.y!,
                                    width: widget.barWidth,
                                    color: Color(budgetBarData.color!),
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: budgetBarData.overLimit!
                                        ? BorderSide(
                                            color:
                                                Color.fromARGB(255, 254, 17, 0),
                                            style: BorderStyle.solid,
                                            width: 3)
                                        : null,
                                    backDrawRodData: BackgroundBarChartRodData(
                                        color: budgetBarData.onLimit!
                                            ? Color.fromARGB(177, 176, 12, 12)
                                            : Color.fromARGB(
                                                152, 224, 224, 224),
                                        show: true,
                                        toY: budgetBarData.limit))
                              ]))
                          .toList(),
                    ),
                    swapAnimationDuration: Duration(milliseconds: 500),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getBottomTiles(double xVal, TitleMeta meta) {
    dynamic style = TextStyle(
        color: Color(widget.barsData[xVal.toInt()].color!),
        fontSize: 14,
        fontWeight: FontWeight.bold);
    Widget text =
        Text(widget.barsData[xVal.toInt()].categoryName!, style: style);
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget getTopTilesStatus(double xVal, TitleMeta meta) {
    return widget.barsData[xVal.toInt()].onLimit!
        ? const SizedBox(
            child: Icon(
              Icons.warning_amber_rounded,
              size: 30,
              color: Colors.red,
            ),
          )
        : const Text('');
  }
}
