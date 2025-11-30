import 'package:flutter/material.dart';
import '../config/app_config.dart';

class CartSummary extends StatelessWidget {
  final double totalHarga;

  const CartSummary({super.key, required this.totalHarga});

  // Format harga dengan separator ribuan
  String _formatHarga(double harga) {
    return "RP ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 20),
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 24, color: AppColors.biru),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.biru),
              child: Text(
                _formatHarga(totalHarga),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(Icons.person, size: 24, color: AppColors.biru),
          ],
        ),
      ),
    );
  }
}
