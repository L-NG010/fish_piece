import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/appbar.dart';
import 'package:fish_it_kasir/widgets/drawer.dart';
import 'package:fish_it_kasir/widgets/search_button.dart';
import 'package:flutter/material.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(title: "Laporan", actions: [
        SearchButton(onSearch: (value) {
          // nanti
        }),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(AppConfig.paddingHorizontal),
          
        ),
    );
  }
}