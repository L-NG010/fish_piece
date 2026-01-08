import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/beranda/beranda_cubit.dart';
import '../../bloc/beranda/beranda_state.dart';
import '../../config/app_config.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  // Format harga dengan separator ribuan
  String _formatHarga(double harga) {
    return "RP ${harga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BerandaCubit, BerandaState>(
      builder: (context, state) {
        final cartItems = context.read<BerandaCubit>().cartItems;
        
        if (cartItems.isEmpty) {
          return const Center(
            child: Text("Keranjang masih kosong"),
          );
        }

        return ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            final productId = item['id'];
            final productName = item['nama'];
            final productPrice = item['harga'];
            final quantity = item['quantity'];

            // Ambil produk dari state untuk mendapatkan informasi stok
            int productStok = 0;
            if (context.read<BerandaCubit>().state is BerandaLoaded) {
              final produkList = (context.read<BerandaCubit>().state as BerandaLoaded).produk;
              final produk = produkList.firstWhere((p) => p.id == productId, orElse: () => produkList.first);
              productStok = produk.stok;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _formatHarga(productPrice),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<BerandaCubit>().decreaseQuantity(productId);
                          },
                          icon: const Icon(
                            Icons.remove,
                            size: 16,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: productStok > quantity 
                            ? () {
                                context.read<BerandaCubit>().increaseQuantity(productId);
                              }
                            : () {
                                // Tampilkan snackbar jika stok tidak mencukupi
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Stok tidak mencukupi! Tersisa: $productStok"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                          icon: Icon(
                            Icons.add,
                            size: 16,
                            color: productStok > quantity ? AppColors.biru : Colors.grey,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}