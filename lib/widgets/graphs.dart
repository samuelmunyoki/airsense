import 'package:airsense/data/models.dart';
import 'package:airsense/util/fetch_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartGraph extends StatefulWidget {
  final List<DeviceData> deviceDataList;
  const LineChartGraph({super.key, required this.deviceDataList});

  @override
  State<LineChartGraph> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartGraph> {
  final List<Color> _gradientColors = [
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255)
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(mainData()),
      ),
    );
  }

  String getLabel(int value) {
    DateTime? date = dateChangeIndices[value];
    if (date != null) {
      return '${date.day}';
    } else {
      return '';
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );
    Widget text;
    text = Text(getLabel(value.toInt() ), style: style, softWrap: false,);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,

    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return Text("${value.toString()}℃",
        style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    List<FlSpot> linespots = [];
    for (int i = 0; i < widget.deviceDataList.length; i++) {
      linespots
          .add(FlSpot(i.toDouble(), widget.deviceDataList[i].temp.toDouble()));
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 2,
        verticalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(51, 0, 0, 0),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(51, 0, 0, 0),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      minX: 0,
      // maxX:  //left blank to show all data,
      minY: 0,
      maxY: 30,
      lineBarsData: [
        LineChartBarData(
          spots: linespots,
          isCurved: true,
          gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 0, 0, 0)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
                colors: _gradientColors
                    .map((color) => color.withOpacity(0.25))
                    .toList(),
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ],
    );
  }
}
