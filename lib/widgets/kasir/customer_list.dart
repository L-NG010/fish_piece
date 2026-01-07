import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pelanggan/pelanggan_cubit.dart';
import '../../bloc/pelanggan/pelanggan_state.dart'; // Tambahkan import ini
import '../../models/pelanggan.dart';
import '../../config/app_config.dart';

class CustomerList extends StatelessWidget {
  const CustomerList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PelangganCubit, dynamic>(
      builder: (context, state) {
        List<Pelanggan> customers = [];
        
        if (state is PelangganLoaded) {
          customers = state.pelangganList; // Perbaikan: properti adalah pelangganList bukan pelanggan
        } else if (state is PelangganLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PelangganError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text("Error: ${state.message}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PelangganCubit>().loadPelanggan();
                  },
                  child: const Text("Muat Ulang"),
                ),
              ],
            ),
          );
        } else {
          // Muat data pelanggan jika belum dimuat
          context.read<PelangganCubit>().loadPelanggan();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (customers.isEmpty) {
          return const Center(
            child: Text("Belum ada pelanggan"),
          );
        }
        
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.biru,
                  child: Text(
                    customer.nama[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(customer.nama),
                subtitle: Text(customer.noWa?.isNotEmpty == true ? customer.noWa! : "No WA tidak tersedia"), // Perbaikan: properti adalah noWa bukan noHp
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            );
          },
        );
      },
    );
  }
}