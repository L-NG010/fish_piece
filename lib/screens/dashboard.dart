import 'package:easy_localization/easy_localization.dart';
import 'package:fish_it_kasir/bloc/dashboard/dashboard_cubit.dart';
import 'package:fish_it_kasir/bloc/dashboard/dashboard_state.dart';
import 'package:fish_it_kasir/widgets/dashboard/barChart.dart';
import 'package:fish_it_kasir/widgets/dashboard/doughnutChart.dart';
import 'package:fish_it_kasir/widgets/dashboard/top_produk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/kpiCard.dart';
import '../widgets/drawer.dart';
import '../widgets/appbar.dart';
import '../config/app_config.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk memuat data saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardCubit>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(title: "dashboard.title".tr(), actions: []),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          String customerCount = "0";
          String stockCount = "0";
          
          if (state is DashboardLoaded) {
            if (state.dashboardData.length >= 2) {
              customerCount = state.dashboardData[0].toString();
              stockCount = state.dashboardData[1].toString();
            } else if (state.dashboardData.length == 1) {
              customerCount = state.dashboardData[0].toString();
            }
          } else if (state is DashboardLoading) {
            customerCount = "...";
            stockCount = "...";
          }

          return SingleChildScrollView(
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
                          value: customerCount,
                          titleSize: 14,
                          valueSize: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KpiCard(
                          icon: Icons.inventory,
                          title: "Stok",
                          value: stockCount,
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
          );
        },
      ),
    );
  }
}