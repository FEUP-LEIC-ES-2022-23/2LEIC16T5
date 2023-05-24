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
      required this.graphContainerHeight,
      required this.currency});
  final List<BudgetBarModel> barsData;
  final double barWidth;
  final double graphMaxY;
  final double spaceBetweenBars;
  final double graphContainerHeight;
  final String currency;

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

    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            color: Colors.black45,
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
                            tooltipBgColor: Colors.blue,
                            direction: TooltipDirection.bottom,
                            tooltipMargin: -55,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                  'Limit: ',
                                  TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  children: [
                                    TextSpan(
                                        text: '${widget.barsData[group.x].limit} ${widget.currency}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(text: '\n'),
                                    TextSpan(
                                        text: 'Value: ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: '${rod.toY} ${widget.currency}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ]);
                            },
                          )),
                      gridData: FlGridData(
                        show: false,),
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
                                            : Color(budgetBarData.color!).withOpacity(0.3),
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
