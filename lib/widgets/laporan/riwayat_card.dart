import 'package:flutter/material.dart';

class RiwayatCard extends StatelessWidget {
  final String? nama; // hanya untuk riwayat penjualan
  final String? produk;
  final String? harga;
  final String? poin; // hanya untuk riwayat penjualan
  final String tanggal;
  final String petugas;
  final String? biaya; // hanya untuk perubahan stok
  final bool isTransaksi; // untuk membedakan transaksi atau stok

  const RiwayatCard({
    super.key,
    this.nama,
    this.produk,
    this.harga,
    this.poin,
    required this.tanggal,
    required this.petugas,
    this.biaya,
    required this.isTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian kiri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isTransaksi) ...[
                      // Untuk transaksi: 3 item di kiri
                      Text(
                        nama!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        produk!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Harga : $harga",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ] else ...[
                      // Untuk stok: 2 item di kiri
                      Text(
                        "Petugas : $petugas",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Biaya : $biaya",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
                
                // Bagian kanan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isTransaksi) ...[
                      // Untuk transaksi: 3 item di kanan
                      Text(
                        "Poin : $poin",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Tanggal : $tanggal",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Petugas : $petugas",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ] else ...[
                      // Untuk stok: 2 item di kanan
                      Text(
                        produk!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Tanggal : $tanggal",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Icon panah HANYA untuk transaksi, di pojok kanan bawah card
        if (isTransaksi)
          Positioned(
            right: 12,
            bottom: 12,
            child: Transform.rotate(
              angle: 0.7854, // 45 derajat dalam radian (π/4)
              child: GestureDetector(
                onTap: () {
                  // onPressed nanti diisi
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 12, // Lebih kecil
                  color: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }
}