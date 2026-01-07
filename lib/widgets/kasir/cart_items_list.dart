import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/beranda/beranda_cubit.dart';
import '../../config/app_config.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BerandaCubit, dynamic>(
      builder: (context, state) {
        // Ambil daftar produk dari state
        final cartItems = context.read<BerandaCubit>().cartItems;
        
        if (cartItems.isEmpty) {
          return const Center(
            child: Text("Keranjang kosong"),
          );
        }
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.biru,
                  child: Text(
                    item['nama'][0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(item['nama']),
                subtitle: Text("Rp ${item['harga'].toStringAsFixed(0)}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: () {
                        context.read<BerandaCubit>().decreaseQuantity(item['id']);
                      },
                    ),
                    Text(item['quantity'].toString()),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () {
                        context.read<BerandaCubit>().increaseQuantity(item['id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}