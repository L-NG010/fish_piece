import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesBarChart extends StatelessWidget {
  const SalesBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(child: _buildChart()),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: const Text(
        "Mingguan",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          _buildLegendItem('Ikan', AppColors.biru),
          _buildLegendItem('Joran', AppColors.ungu),
          _buildLegendItem('Kapal', AppColors.pink),
          _buildLegendItem('Item', AppColors.oren),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.shade400, width: 1),
            bottom: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: _getBottomTitles,
            ),
          ),
        ),
        barGroups: _getBarGroups(),
        groupsSpace: 12,
        maxY: 14,
      ),
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final index = value.toInt();
    
    if (index >= 0 && index < days.length) {
      return Text(
        days[index],
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      );
    }
    return const Text('');
  }

  List<BarChartGroupData> _getBarGroups() {
    return [
      _createBarGroup(0, [5, 3, 2, 4]),
      _createBarGroup(1, [8, 5, 6, 3]),
      _createBarGroup(2, [4, 7, 3, 5]),
      _createBarGroup(3, [10, 4, 8, 6]),
      _createBarGroup(4, [6, 9, 4, 7]),
      _createBarGroup(5, [12, 8, 10, 5]),
      _createBarGroup(6, [7, 6, 5, 9]),
    ];
  }

  BarChartGroupData _createBarGroup(int x, List<double> values) {
    return BarChartGroupData(
      x: x,
      barRods: [
        _createBarRod(values[0], AppColors.biru),
        _createBarRod(values[1], AppColors.ungu),
        _createBarRod(values[2], AppColors.pink),
        _createBarRod(values[3], AppColors.oren),
      ],
    );
  }

  BarChartRodData _createBarRod(double value, Color color) {
    return BarChartRodData(
      toY: value,
      color: color,
      width: 8,
      borderRadius: BorderRadius.circular(2),
    );
  }
}