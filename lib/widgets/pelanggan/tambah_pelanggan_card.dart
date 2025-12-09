// lib/widgets/pelanggan/tambah_pelanggan_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_cubit.dart';
import 'package:fish_it_kasir/bloc/pelanggan/pelanggan_state.dart';
import 'package:fish_it_kasir/config/app_config.dart';
import '../notification_card.dart';

class TambahPelangganCard extends StatefulWidget {
  const TambahPelangganCard({super.key});

  @override
  State<TambahPelangganCard> createState() => _TambahPelangganCardState();
}

class _TambahPelangganCardState extends State<TambahPelangganCard> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usnRobloxController = TextEditingController();
  final _noWaController = TextEditingController();
  bool _isLoading = false;

  void _showSuccessNotification(String message) {
    showNotification(context: context, message: message, isSuccess: true);
  }

  void _showErrorNotification(String title, String message) {
    showNotification(
      context: context,
      title: title,
      message: message,
      isSuccess: false,
    );
  }

  String _getErrorMessage(dynamic e) {
    final errorStr = e.toString();

    if (errorStr.contains('Username Roblox')) {
      return errorStr.replaceAll('Exception: ', '');
    }

    if (errorStr.contains('duplicate key')) {
      return 'Username Roblox sudah digunakan. Gunakan username lain.';
    }

    return 'Terjadi kesalahan. Coba lagi.';
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await context.read<PelangganCubit>().tambahPelanggan(
          nama: _namaController.text,
          usnRoblox: _usnRobloxController.text,
          noWa: _noWaController.text.isNotEmpty ? _noWaController.text : null,
        );
      } catch (e) {
        print('❌ Unexpected error: $e');
        setState(() {
          _isLoading = false;
        });
        _showErrorNotification('Kesalahan Tidak Terduga', _getErrorMessage(e));
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usnRobloxController.dispose();
    _noWaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PelangganCubit, PelangganState>(
      listenWhen: (previous, current) =>
          current is PelangganAddSuccess || current is PelangganAddFailure,
      listener: (context, state) {
        if (state is PelangganAddSuccess) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context, true);
          Future.microtask(() {
            _showSuccessNotification(state.message);
          });
        }

        if (state is PelangganAddFailure) {
          setState(() {
            _isLoading = false;
          });
          _showErrorNotification(
            'Gagal Menambahkan Pelanggan',
            _getErrorMessage(state.message),
          );
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tambah Pelanggan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Form fields
                  TextFormField(
                    controller: _namaController,
                    enabled: !_isLoading,
                    keyboardType: TextInputType.name,
                    // TIDAK ADA inputFormatters → bebas ketik apa saja
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      hintText: 'Masukkan nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.biru,
                          width: 2,
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    cursorColor: AppColors.biru,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      // Hanya boleh huruf dan spasi
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
                        return 'Nama hanya boleh huruf dan spasi';
                      }
                      if (value.trim().length < 2) {
                        return 'Nama terlalu pendek';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _usnRobloxController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: 'Username Roblox',
                      hintText: '@username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.biru,
                          width: 2,
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    cursorColor: AppColors.biru,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username Roblox wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _noWaController,
                    enabled: !_isLoading,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13), // Maksimal 13 angka
                    ],
                    decoration: InputDecoration(
                      labelText: 'Nomor WhatsApp (Opsional)',
                      hintText: '812xxxxxxxx',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.biru,
                          width: 2,
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixText: '+62 ',
                      prefixStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    cursorColor: AppColors.biru,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null; // Opsional, boleh kosong
                      }

                      // Cek tidak boleh dimulai dengan 0
                      if (value.startsWith('0')) {
                        return 'Jangan tulis angka 0 di depan. Mulai dari 8';
                      }

                      // Cek harus dimulai dengan 8
                      if (!value.startsWith('8')) {
                        return 'Harus dimulai dengan angka 8';
                      }

                      // Cek minimal 10 angka
                      if (value.length < 10) {
                        return 'Minimal 10 angka';
                      }

                      // Cek maksimal 13 angka
                      if (value.length > 13) {
                        return 'Maksimal 13 angka';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      // Auto remove 0 jika diketik di depan
                      if (value.isNotEmpty && value.startsWith('0')) {
                        _noWaController.text = value.substring(1);
                        _noWaController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _noWaController.text.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.biru,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
