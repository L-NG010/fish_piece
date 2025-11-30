import 'package:fish_it_kasir/widgets/dashboard/barChart.dart';
import 'package:fish_it_kasir/widgets/dashboard/doughnutChart.dart';
import 'package:fish_it_kasir/widgets/dashboard/top_produk.dart';
import 'package:flutter/material.dart';
import '../widgets/kpiCard.dart';
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../config/app_config.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(title: "Dashboard", actions: []),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConfig.paddingHorizontal),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      icon: Icons.person,
                      title: "Pelanggan",
                      value: "4",
                      titleSize: 14,
                      valueSize: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      icon: Icons.layers,
                      title: "Stok",
                      value: "550",
                      titleSize: 14,
                      valueSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TopProdukCard(),
              const SizedBox(height: 12),
              SizedBox(height: 250, child: DoughnutChart()),
              SizedBox(height: 20),
              SizedBox(height: 300, child: SalesBarChart()),
            ],
          ),
        ),
      ),
    );
  }
}
