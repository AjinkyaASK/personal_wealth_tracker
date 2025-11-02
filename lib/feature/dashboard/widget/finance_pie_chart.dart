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

class FinancePieChart extends StatefulWidget {
  const FinancePieChart({super.key, required this.data, this.title});

  final List<FinancePieChartDataItem> data;
  final String? title;

  @override
  State<FinancePieChart> createState() => _FinancePieChartState();
}

class _FinancePieChartState extends State<FinancePieChart> {
  List<PieChartSectionData> showingSections() {
    final double total = widget.data.fold(0.0, (sum, item) => sum + item.value);
    return widget.data.map((item) {
      final double value = ((item.value / total) * 100).roundToDouble();
      return PieChartSectionData(
        color: item.color,
        value: value,
        title: '$value%',
        titleStyle: TextStyle(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Text(
              widget.title!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(
          child: Row(
            children: [
              // Chart
              Expanded(
                flex: 3,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 32,
                    sections: showingSections(),
                  ),
                ),
              ),
              // Legends
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.data.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(width: 16, height: 16, color: item.color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
