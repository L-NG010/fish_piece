import 'dart:io';
import 'package:fish_it_kasir/bloc/produk/produk_cubit.dart';
import 'package:fish_it_kasir/bloc/produk/produk_state.dart';
import 'package:fish_it_kasir/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../popup_kelangkaan.dart';
import 'package:fish_it_kasir/models/produk.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../notification_card.dart';

class EditProdukCard extends StatefulWidget {
  final Produk produk;

  const EditProdukCard({super.key, required this.produk});

  @override
  State<EditProdukCard> createState() => _EditProdukCardState();
}

class _EditProdukCardState extends State<EditProdukCard> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  String? _selectedKelangkaan;
  String? _selectedKategori;
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _hapusGambar = false;
  Uint8List? _webImage;

  final List<String> _kategoriList = ['Ikan', 'Joran', 'Kapal', 'Item'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final produk = widget.produk;

    _namaController.text = produk.nama;
    _stokController.text = produk.stok.toString();
    _selectedKategori = _getKategoriString(produk.kategori);
    _selectedKelangkaan = (produk.kelangkaan.index + 1).toString();
    _hargaBeliController.text = produk.hargaBeli.toStringAsFixed(0);
    _hargaJualController.text = produk.hargaJual.toStringAsFixed(0);
  }

  String _getKategoriString(Kategori kategori) {
    switch (kategori) {
      case Kategori.ikan:
        return 'Ikan';
      case Kategori.joran:
        return 'Joran';
      case Kategori.kapal:
        return 'Kapal';
      case Kategori.item:
        return 'Item';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    super.dispose();
  }

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
            _hapusGambar = false;
          });
        } else {
          setState(() {
            _selectedImage = File(pickedFile.path);
            _hapusGambar = false;
          });
        }
      }
    } catch (e) {
      _showErrorNotification('Gagal memilih gambar', e.toString());
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _webImage = null;
      _hapusGambar = true;
    });
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        final kelangkaanIndex = int.parse(_selectedKelangkaan!) - 1;

        XFile? xFile;
        if (_selectedImage != null) {
          xFile = XFile(_selectedImage!.path);
        } else if (_webImage != null) {
          xFile = XFile.fromData(
            _webImage!,
            name: 'edit_${DateTime.now().millisecondsSinceEpoch}.png',
          );
        }

        print('🚀 Memulai edit produk...');

        await context.read<ProdukCubit>().editProduk(
          produkId: widget.produk.id.toString(),
          nama: _namaController.text,
          stok: int.parse(_stokController.text),
          kategori: Kategori.values[_kategoriList.indexOf(_selectedKategori!)],
          kelangkaan: Kelangkaan.values[kelangkaanIndex],
          hargaBeli: double.parse(_hargaBeliController.text),
          hargaJual: double.parse(_hargaJualController.text),
          gambarFile: xFile,
          hapusGambar: _hapusGambar,
        );
      } catch (e) {
        print('❌ Unexpected error: $e');
        setState(() {
          _isUploading = false;
        });
        _showErrorNotification('Kesalahan Tidak Terduga', _getErrorMessage(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProdukCubit, ProdukState>(
      listenWhen: (previous, current) =>
          current is ProdukEditSuccess || current is ProdukEditFailure,
      listener: (context, state) {
        print('🎯 Edit Dialog Listener: ${state.runtimeType}');
        print('🎯 mounted: ${mounted}');

        if (state is ProdukEditSuccess) {
          print('✅ Edit Success - menutup dialog');

          if (mounted) {
            setState(() {
              _isUploading = false;
            });
          }

          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            print('✅ Navigator canPop, closing dialog...');
            navigator.pop(true);
            print('✅ Dialog closed');

            Future.microtask(() {
              _showSuccessNotification(state.message);
            });
          } else {
            print('❌ Navigator cannot pop');
          }
        }

        if (state is ProdukEditFailure) {
          print('❌ Edit Failure: ${state.message}');

          if (mounted) {
            setState(() {
              _isUploading = false;
            });
          }

          _showErrorNotification(
            'Gagal Mengupdate Produk',
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
                        'Edit Produk',
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
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _isUploading ? null : _pickImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              image: _buildImageDecoration(),
                            ),
                            child: _buildImageChild(),
                          ),
                        ),
                        if (widget.produk.gambarUrl != null &&
                            widget.produk.gambarUrl!.isNotEmpty &&
                            !_hapusGambar)
                          TextButton(
                            onPressed: _isUploading ? null : _removeImage,
                            child: const Text(
                              'Hapus Foto',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form fields (sama dengan TambahProdukCard)
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
                              return 'Nama wajib diisi';
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
                              TextInputType.text, // boleh ketik apa saja
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
                            hintText: 'Ikan',
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
                            final cleaned = value.trim().replaceAll(',', '');
                            final n = double.tryParse(cleaned);
                            if (n == null) {
                              return 'Harga beli harus angka';
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
                            final cleaned = value.trim().replaceAll(',', '');
                            final n = double.tryParse(cleaned);
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
                          onPressed: _isUploading ? null : _submitForm,
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

  DecorationImage? _buildImageDecoration() {
    if (_webImage != null) {
      return DecorationImage(image: MemoryImage(_webImage!), fit: BoxFit.cover);
    } else if (_selectedImage != null) {
      return DecorationImage(
        image: FileImage(_selectedImage!),
        fit: BoxFit.cover,
      );
    } else if (widget.produk.gambarUrl != null &&
        widget.produk.gambarUrl!.isNotEmpty &&
        !_hapusGambar) {
      return DecorationImage(
        image: NetworkImage(widget.produk.gambarUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  Widget? _buildImageChild() {
    if ((_webImage == null && _selectedImage == null) &&
        (widget.produk.gambarUrl == null ||
            widget.produk.gambarUrl!.isEmpty ||
            _hapusGambar)) {
      return Column(
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
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      );
    }
    return null;
  }
}
