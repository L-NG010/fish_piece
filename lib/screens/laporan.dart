import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/appbar.dart';
import 'package:fish_it_kasir/widgets/drawer.dart';
import 'package:fish_it_kasir/widgets/kpiCard.dart';
import 'package:fish_it_kasir/widgets/laporan/riwayat_card.dart';
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
      appBar: CustomAppBar(
        title: "Laporan",
        actions: [
          SearchButton(
            onSearch: (value) {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConfig.paddingHorizontal),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<String>(
                      value: "Mingguan",
                      items: const [
                        DropdownMenuItem(
                          value: "Hari ini",
                          child: Text("Hari ini"),
                        ),
                        DropdownMenuItem(
                          value: "Mingguan",
                          child: Text("Mingguan"),
                        ),
                        DropdownMenuItem(
                          value: "Bulanan",
                          child: Text("Bulanan"),
                        ),
                      ],
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "tanggal/bulan/tahun",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 4,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.print_rounded),
                  label: const Text("Cetak"),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      icon: Icons.monetization_on,
                      title: "Modal",
                      value: "120.000,00",
                      titleSize: 12,
                      valueSize: 12,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KpiCard(
                      icon: Icons.paid,
                      title: "Pendapatan",
                      value: "192.000,00",
                      titleSize: 12,
                      valueSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      icon: Icons.trending_up,
                      title: "Laba",
                      value: "100.000,00",
                      titleSize: 12,
                      isPlus: true,
                      valueSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                "Riwayat Transaksi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              RiwayatCard(
                nama: "Lnata",
                produk: "Elshark Gran Maja x2",
                harga: "Rp 140.000,00",
                poin: "120",
                tanggal: "09/10/2025",
                petugas: "Lnata",
                isTransaksi: true,
              ),
              const SizedBox(height: 12),
              RiwayatCard(
                nama: "Lnata",
                produk: "Megalodon",
                harga: "Rp 60.000,00",
                poin: "120",
                tanggal: "09/10/2025",
                petugas: "Lnata",
                isTransaksi: true,
              ),
              const SizedBox(height: 12),
              RiwayatCard(
                nama: "Andrew",
                produk: "Elshark Gran Maja",
                harga: "Rp 70.000,00",
                poin: "60",
                tanggal: "07/10/2025",
                petugas: "Lnata",
                isTransaksi: true,
              ),

              const SizedBox(height: 32),

              const Text(
                "Riwayat Perubahan Stok",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              RiwayatCard(
                produk: "Elshark Gran Maja 10 → 12",
                biaya: "Rp 120.000,00",
                tanggal: "07/10/2025",
                petugas: "Lnata",
                isTransaksi: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
