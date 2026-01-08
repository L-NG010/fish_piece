import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/beranda/beranda_cubit.dart';
import '../../bloc/beranda/beranda_state.dart';
import '../../config/app_config.dart';
import './payment_dialog.dart';
import './cart_items_list.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  // Format harga dengan separator ribuan
  String _formatHarga(double harga) {
    return "RP ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BerandaCubit, BerandaState>(
      builder: (context, state) {
        final currentTotal = context.read<BerandaCubit>().getTotalHarga();
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppConfig.paddingHorizontal, vertical: 12),
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            height: 500,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Keranjang Belanja",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: CartItemsList(),
                                ),
                                const SizedBox(height: 10),
                                // Menambahkan BlocBuilder untuk total harga agar real-time
                                BlocBuilder<BerandaCubit, BerandaState>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total:",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _formatHarga(context.read<BerandaCubit>().getTotalHarga()),
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    );
                                  }
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: context.read<BerandaCubit>().cartItems.isEmpty 
                                    ? null 
                                    : () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogPembayaran(harga: context.read<BerandaCubit>().getTotalHarga());
                                          },
                                        );
                                      },
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.biru),
                                  child: const Text(
                                    "Proses Pembayaran",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.biru),
                  child: Text(
                    _formatHarga(currentTotal),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Icon(Icons.person, size: 24, color: AppColors.biru),
              ],
            ),
          ),
        );
      }
    );
  }
}