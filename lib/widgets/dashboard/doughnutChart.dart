import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DoughnutChart extends StatelessWidget {
  const DoughnutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "Harian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24), // padding bawah tambahan
                child: Row(
                  children: [
                    // Chart benar-benar di tengah horizontal
                    Expanded(
                      flex: 2, // dibuat seimbang agar chart tepat di tengah card
                      child: Center(
                        child: SizedBox(
                          width: 210,
                          height: 210,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 52,
                              startDegreeOffset: -90,
                              sections: _getSections(),
                              pieTouchData: PieTouchData(enabled: false),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Jarak antara chart dan legend
                    const SizedBox(width: 20),

                    // Legend di sisi kanan
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem('Ikan', AppColors.biru),
                          const SizedBox(height: 12),
                          _buildLegendItem('Joran', AppColors.ungu),
                          const SizedBox(height: 12),
                          _buildLegendItem('Kapal', AppColors.pink),
                          const SizedBox(height: 12),
                          _buildLegendItem('Item', AppColors.oren),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    return [
      _createSection(40, AppColors.biru, '40%'),
      _createSection(30, AppColors.pink, '30%'),
      _createSection(20, AppColors.ungu, '20%'),
      _createSection(10, AppColors.oren, '10%'),
    ];
  }

  PieChartSectionData _createSection(
    double value,
    Color color,
    String title,
  ) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: title,
      radius: 45,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
