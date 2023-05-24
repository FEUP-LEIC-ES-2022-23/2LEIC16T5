import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../Model/BudgetBarModel.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart(
      {super.key,
      required this.barsData,
      required this.graphHeight,
      this.spaceBetweenSections,
      this.strokeWidth,
      required this.fontSize,
      this.size});
  final List<BudgetBarModel> barsData;
  final double graphHeight;
  final double? spaceBetweenSections;
  final double? strokeWidth;
  final double fontSize;
  final double? size;
  @override
  State<MyPieChart> createState() => BarGraphState();
}

class BarGraphState extends State<MyPieChart> {
  double total = 0;
  int touchedIdx = -1;
  @override
  Widget build(BuildContext context) {
    total = 0;

    double graphWidth = MediaQuery.of(context).size.width;

    List<BudgetBarModel> nonEmptySections =
        NonEmptyPieChartSections(widget.barsData);
    bool hasSections = nonEmptySections.isNotEmpty;
    if (hasSections) {
      for (BudgetBarModel section in widget.barsData) {
        total += section.value!;
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          //aqui para editar as propriedades do grafico em geral!

          child: Container(
            width: graphWidth,
            height: widget.graphHeight,
            child: PieChart(PieChartData(
                startDegreeOffset: 90,
                pieTouchData: hasSections
                    ? PieTouchData(touchCallback: (event, pieTouchResponse) {
                        if (!hasSections) {
                          return;
                        }
                        if (event is FlLongPressEnd || event is FlPanEndEvent) {
                          if (mounted) {
                            setState(() {
                              touchedIdx = -1;
                            });
                          }
                        } else {
                          if (mounted) {
                            if (pieTouchResponse != null &&
                                pieTouchResponse.touchedSection != null) {
                              setState(() {
                                touchedIdx = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            }
                          }
                        }
                      })
                    : null,
                centerSpaceRadius: widget.size,
                borderData: FlBorderData(show: false),
                sectionsSpace: widget.spaceBetweenSections,
                sections:
                    hasSections ? getChartSections(nonEmptySections) : [])),
          ),
        ),
      ],
    );
  }

  List<BudgetBarModel> NonEmptyPieChartSections(List<BudgetBarModel> barsData) {
    List<BudgetBarModel> temp = [];
    for (BudgetBarModel bar in barsData) {
      if (bar.value != 0) {
        temp.add(bar);
      }
    }
    /*if (temp.isEmpty) {
      temp.add(BudgetBarModel(categoryID: '', userID: '', value: 0, color: 0));
    }*/
    return temp;
  }

  //Aqui para mudar propriedades de cada secao tipo cor, texto mostrado etc etc

  List<PieChartSectionData> getChartSections(List<BudgetBarModel> sections) {
    return sections
        .asMap()
        .map<int, PieChartSectionData>((idx, data) {
          final bool isTouched = idx == touchedIdx;
          final double percentage = data.value! / total;
          final bool nullValue =
              (data.value == 0 && total == 0 || data.value == 0 && total != 0);

          final section = PieChartSectionData(
              radius:
                  isTouched ? widget.strokeWidth! * 1.75 : widget.strokeWidth,
              color: nullValue ? Colors.grey[200] : Color(data.color!),
              // verificar qnd chegar a casa
              value: nullValue ? 0 : percentage,
              title: nullValue
                  ? ''
                  : (isTouched
                      ? '${(percentage * 100).toStringAsFixed(0)}%'
                      : data.categoryName),
              titleStyle: TextStyle(
                  fontSize:
                      isTouched ? widget.fontSize * 1.75 : widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                        // bottomLeft
                        offset: Offset(0, 2.7),
                        color: Colors.black54),
                  ]));
          return MapEntry(idx, section);
        })
        .values
        .toList();
  }
}
