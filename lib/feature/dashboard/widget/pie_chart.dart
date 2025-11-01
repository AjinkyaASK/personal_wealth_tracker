import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FinancePieChartDataItem {
  final String title;
  final double value;
  final Color color;

  FinancePieChartDataItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

class FinancePieChart extends StatelessWidget {
  const FinancePieChart({super.key, required this.data});

  final List<FinancePieChartDataItem> data;

  List<PieChartSectionData> showingSections() {
    final double total = data.fold(0.0, (sum, item) => sum + item.value);
    return data.map((item) {
      final double value = ((item.value / total) * 100).roundToDouble();
      return PieChartSectionData(
        color: item.color,
        value: value,
        title: '$value%',
        titleStyle: TextStyle(fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Chart
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections(),
            ),
          ),
        ),
        // Legends
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Container(width: 16, height: 16, color: item.color),
                      const SizedBox(width: 8),
                      Text(item.title),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
