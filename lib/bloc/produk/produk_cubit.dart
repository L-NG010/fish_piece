// produk_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/produk.dart';
import '../../services/produk.dart';
import 'produk_state.dart';

class ProdukCubit extends Cubit<ProdukState> {
  final ProdukService service;

  ProdukCubit(this.service) : super(ProdukInitial());

  // Load produk (untuk parent screen)
  Future<void> loadProduk({bool forceReload = false}) async {
    if (!forceReload && state is ProdukLoaded) return;

    emit(ProdukLoading());
    try {
      final data = await service.getProduk();
      emit(ProdukLoaded(data));
    } catch (e) {
      emit(ProdukError(e.toString()));
    }
  }

  // Tambah produk (untuk dialog)
  Future<void> tambahProduk({
    required String nama,
    required int stok,
    required Kategori kategori,
    required Kelangkaan kelangkaan,
    required double hargaBeli,
    required double hargaJual,
    XFile? gambarFile,
  }) async {
    emit(ProdukAddInProgress());
    
    try {
      await service.tambahProduk(
        nama: nama,
        stok: stok,
        kategori: kategori,
        kelangkaan: kelangkaan,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        gambarFile: gambarFile,
      );

      emit(ProdukAddSuccess('Produk "$nama" berhasil ditambahkan'));
      await _silentLoadProduk();
      
    } catch (e) {
      emit(ProdukAddFailure(e.toString()));
    }
  }

  // Edit produk
  Future<void> editProduk({
    required String produkId,
    required String nama,
    required int stok,
    required Kategori kategori,
    required Kelangkaan kelangkaan,
    required double hargaBeli,
    required double hargaJual,
    XFile? gambarFile,
    bool hapusGambar = false,
  }) async {
    emit(ProdukEditInProgress());
    
    try {
      final updatedProduk = await service.editProduk(
        produkId: produkId,
        nama: nama,
        stok: stok,
        kategori: kategori,
        kelangkaan: kelangkaan,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        gambarFile: gambarFile,
        hapusGambar: hapusGambar,
      );

      emit(ProdukEditSuccess('Produk "$nama" berhasil diperbarui', updatedProduk));
      await _silentLoadProduk();
      
    } catch (e) {
      emit(ProdukEditFailure(e.toString()));
    }
  }

  // Delete produk
  Future<void> deleteProduk(String produkId) async {
    emit(ProdukDeleteInProgress());
    
    try {
      await service.deleteProduk(produkId);
      emit(ProdukDeleteSuccess('Produk berhasil dihapus', produkId));
      await _silentLoadProduk();
      
    } catch (e) {
      emit(ProdukDeleteFailure(e.toString()));
    }
  }

  // Helper: Load produk secara silent
  Future<void> _silentLoadProduk() async {
    try {
      final data = await service.getProduk();
      emit(ProdukLoaded(data));
    } catch (e) {
      print('⚠️ Gagal refresh data: $e');
      // Tetap di state terakhir
    }
  }
  
  // Reset ke state loaded
  void resetToLoaded(List<Produk> produk) {
    emit(ProdukLoaded(produk));
  }
}