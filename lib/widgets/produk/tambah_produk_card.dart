import 'package:fish_it_kasir/bloc/produk/produk_cubit.dart';
import 'package:fish_it_kasir/bloc/produk/produk_state.dart';
import 'package:fish_it_kasir/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../popup_kelangkaan.dart';
import 'package:fish_it_kasir/models/produk.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../notification_card.dart';

class TambahProdukCard extends StatefulWidget {
  const TambahProdukCard({super.key});

  @override
  State<TambahProdukCard> createState() => _TambahProdukCardState();
}

class _TambahProdukCardState extends State<TambahProdukCard> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  String? _selectedKelangkaan;
  String? _selectedKategori;
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final createdBy = Supabase.instance.client.auth.currentUser!.id;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  final List<String> _kategoriList = ['Ikan', 'Joran', 'Kapal', 'Item'];

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    super.dispose();
  }

  Uint8List? _webImage;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        } else {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      }
    } catch (e) {
      _showErrorNotification('Gagal memilih gambar', e.toString());
    }
  }

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

    if (errorStr.contains('Nama produk')) {
      return errorStr.replaceAll('Exception: ', '');
    }

    if (errorStr.contains('duplicate key')) {
      return 'Nama produk sudah digunakan. Gunakan nama lain.';
    }

    if (errorStr.contains('upload')) {
      return 'Gagal mengupload gambar. Coba gambar lain.';
    }

    return 'Terjadi kesalahan. Coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProdukCubit, ProdukState>(
      listenWhen: (previous, current) =>
          current is ProdukAddSuccess || current is ProdukAddFailure,
      listener: (context, state) {
        print('🎯 Dialog Listener: ${state.runtimeType}');
        print('🎯 mounted: ${mounted}');

        if (state is ProdukAddSuccess) {
          print('✅ Success - menutup dialog');

          // Reset loading state
          if (mounted) {
            setState(() {
              _isUploading = false;
            });
          }

          // Tutup dialog TERLEBIH DAHULU
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            print('✅ Navigator canPop, closing dialog...');
            navigator.pop(true);
            print('✅ Dialog closed');

            // Tampilkan notifikasi setelah dialog tertutup
            Future.microtask(() {
              _showSuccessNotification(state.message);
            });
          } else {
            print('❌ Navigator cannot pop');
          }
        }

        if (state is ProdukAddFailure) {
          print('❌ Failure: ${state.message}');

          // Set loading false
          if (mounted) {
            setState(() {
              _isUploading = false;
            });
          }

          // Tampilkan error
          _showErrorNotification(
            'Gagal Menambahkan Produk',
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
                        'Tambah Produk',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _isUploading
                            ? null
                            : () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Image picker
                  Center(
                    child: GestureDetector(
                      onTap: _isUploading ? null : _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          image: kIsWeb
                              ? (_webImage != null
                                    ? DecorationImage(
                                        image: MemoryImage(_webImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null)
                              : (_selectedImage != null
                                    ? DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                        ),
                        child: (_selectedImage == null && _webImage == null)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.grey.shade400,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Upload Foto',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form fields
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _namaController,
                          enabled: !_isUploading,
                          decoration: InputDecoration(
                            labelText: 'Nama Produk',
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
                            if (value == null || value.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _stokController,
                          enabled: !_isUploading,
                          keyboardType:
                              TextInputType.text, // boleh huruf/simbol
                          decoration: InputDecoration(
                            labelText: 'Stok',
                            hintText: 'Jumlah',
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
                              return 'Wajib diisi';
                            }
                            final n = int.tryParse(value.trim());
                            if (n == null) {
                              return 'Harus angka bulat';
                            }
                            if (n < 0) {
                              return 'Tidak boleh negatif';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: FormField<String>(
                          validator: (value) {
                            if (_selectedKelangkaan == null ||
                                _selectedKelangkaan!.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
                          builder: (formFieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Kelangkaan',
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
                                    errorText: formFieldState.errorText,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: IgnorePointer(
                                    ignoring: _isUploading,
                                    child: PopupKelangkaan(
                                      selected: _selectedKelangkaan,
                                      onChanged: (value) {
                                        if (!_isUploading) {
                                          setState(() {
                                            _selectedKelangkaan = value;
                                          });
                                          formFieldState.didChange(value);
                                        }
                                      },
                                      useIcon: false,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedKategori,
                          decoration: InputDecoration(
                            labelText: 'Kategori',
                            hintText: 'None',
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: _kategoriList.map((kategori) {
                            return DropdownMenuItem(
                              value: kategori,
                              child: Text(kategori),
                            );
                          }).toList(),
                          onChanged: _isUploading
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedKategori = value;
                                  });
                                },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hargaBeliController,
                          enabled: !_isUploading,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Harga Beli',
                            hintText: '0',
                            prefixText: 'Rp ',
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
                              return 'Wajib diisi';
                            }
                            final n = double.tryParse(
                              value.trim().replaceAll(',', ''),
                            );
                            if (n == null) {
                              return 'Harus angka';
                            }
                            if (n < 0) {
                              return 'Tidak boleh negatif';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _hargaJualController,
                          enabled: !_isUploading,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Harga Jual',
                            hintText: '0',
                            prefixText: 'Rp ',
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
                              return 'Wajib diisi';
                            }
                            final n = double.tryParse(
                              value.trim().replaceAll(',', ''),
                            );
                            if (n == null) {
                              return 'Harus angka';
                            }
                            if (n < 0) {
                              return 'Tidak boleh negatif';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isUploading
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
                          onPressed: _isUploading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isUploading = true;
                                    });

                                    try {
                                      final kelangkaanIndex =
                                          int.parse(_selectedKelangkaan!) - 1;

                                      XFile? xFile;
                                      if (_selectedImage != null) {
                                        xFile = XFile(_selectedImage!.path);
                                      } else if (_webImage != null) {
                                        xFile = XFile.fromData(
                                          _webImage!,
                                          name:
                                              'upload_${DateTime.now().millisecondsSinceEpoch}.png',
                                        );
                                      }

                                      print('🚀 Memulai tambah produk...');

                                      // Panggil cubit (listener akan handle success/failure)
                                      await context
                                          .read<ProdukCubit>()
                                          .tambahProduk(
                                            nama: _namaController.text,
                                            stok: int.parse(
                                              _stokController.text,
                                            ),
                                            kategori:
                                                Kategori.values[_kategoriList
                                                    .indexOf(
                                                      _selectedKategori!,
                                                    )],
                                            kelangkaan: Kelangkaan
                                                .values[kelangkaanIndex],
                                            hargaBeli: double.parse(
                                              _hargaBeliController.text,
                                            ),
                                            hargaJual: double.parse(
                                              _hargaJualController.text,
                                            ),
                                            createdBy: createdBy,
                                            gambarFile: xFile,
                                          );
                                    } catch (e) {
                                      print('❌ Unexpected error: $e');
                                      setState(() {
                                        _isUploading = false;
                                      });
                                      _showErrorNotification(
                                        'Kesalahan Tidak Terduga',
                                        _getErrorMessage(e),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.biru,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isUploading
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
