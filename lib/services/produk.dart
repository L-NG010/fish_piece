import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/produk.dart';

class ProdukService {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Produk>> getProduk() async {
    try {
      final response = await client.from('produk').select();
      if (response.isEmpty) return [];

      List<Produk> result = [];
      for (var item in response) {
        final riwayat = await client
            .from('riwayat_stok')
            .select()
            .eq('produk_id', item['id'])
            .order('created_at', ascending: false)
            .limit(1);

        final stokTerbaru = riwayat.isNotEmpty
            ? riwayat.first['stok_sesudah'] as int
            : 0;

        result.add(Produk.fromJson(item, stokTerbaru));
      }
      return result;
    } catch (error) {
      throw Exception('Gagal mengambil data produk: $error');
    }
  }

  Future<void> tambahProduk({
    required String nama,
    required int stok,
    required Kategori kategori,
    required Kelangkaan kelangkaan,
    required double hargaBeli,
    required double hargaJual,
    XFile? gambarFile,
  }) async {
    String? gambarUrl;
    String? uploadedFileName;

    try {
      // === STEP 1: VALIDASI NAMA ===
      final existingProduct = await client
          .from('produk')
          .select()
          .eq('nama', nama)
          .maybeSingle();

      if (existingProduct != null) {
        throw 'Nama produk "$nama" sudah ada. Gunakan nama yang berbeda.';
      }

      // === STEP 2: UPLOAD GAMBAR ===
      if (gambarFile != null) {
        final fileExt = gambarFile.name.split('.').last;
        uploadedFileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        // Handle upload untuk web dan mobile
        if (kIsWeb) {
          // Untuk web
          final bytes = await gambarFile.readAsBytes();
          await client.storage
              .from('produk')
              .uploadBinary(uploadedFileName, bytes,
                  fileOptions: FileOptions(contentType: 'image/$fileExt'));
        } else {
          // Untuk mobile
          final bytes = await gambarFile.readAsBytes();
          await client.storage
              .from('produk')
              .uploadBinary(uploadedFileName, bytes);
        }

        gambarUrl = client.storage
            .from('produk')
            .getPublicUrl(uploadedFileName);
      }

      // === STEP 3: INSERT PRODUK ===
      final insert = await client
          .from('produk')
          .insert({
            'nama': nama,
            'kategori': (kategori.index + 1).toString(),
            'kelangkaan': (kelangkaan.index + 1).toString(),
            'harga_beli': hargaBeli,
            'harga_jual': hargaJual,
            'gambar_url': gambarUrl,
          })
          .select()
          .single();

      // === STEP 4: BUAT RIWAYAT STOK AWAL ===
      final totalHarga = hargaBeli * stok;
      final createdBy = client.auth.currentUser?.id ?? 'system';

      await client.from('riwayat_stok').insert({
        'produk_id': insert['id'],
        'stok_sebelum': 0,
        'stok_sesudah': stok,
        'total_harga': totalHarga,
        'created_by': createdBy,
      });
    } catch (e) {
      // === ROLLBACK GAMBAR JIKA ERROR ===
      if (uploadedFileName != null) {
        try {
          await client.storage.from('produk').remove([uploadedFileName]);
        } catch (deleteError) {
          print('⚠️ Gagal rollback gambar: $deleteError');
        }
      }

      if (e.toString().contains('duplicate key')) {
        throw 'Nama produk "$nama" sudah ada. Gunakan nama yang berbeda.';
      }

      throw 'Gagal menambahkan produk: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }

  Future<Produk> editProduk({
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
    String? gambarUrl;
    String? uploadedFileName;

    try {
      // === STEP 1: VALIDASI NAMA (kecuali produk itu sendiri) ===
      final existingProduct = await client
          .from('produk')
          .select()
          .eq('nama', nama)
          .neq('id', produkId)
          .maybeSingle();

      if (existingProduct != null) {
        throw 'Nama produk "$nama" sudah ada. Gunakan nama yang berbeda.';
      }

      // === STEP 2: GET DATA SEBELUMNYA ===
      final currentProduk = await client
          .from('produk')
          .select()
          .eq('id', produkId)
          .single();

      final hargaBeliLama = (currentProduk['harga_beli'] as num).toDouble();

      // Ambil riwayat stok terakhir
      final riwayatTerakhir = await client
          .from('riwayat_stok')
          .select()
          .eq('produk_id', produkId)
          .order('created_at', ascending: false)
          .limit(1);

      final stokSebelum = riwayatTerakhir.isNotEmpty 
          ? riwayatTerakhir.first['stok_sesudah'] as int
          : 0;

      // === STEP 3: HANDLE GAMBAR ===
      if (gambarFile != null) {
        // Upload gambar baru
        final fileExt = gambarFile.name.split('.').last;
        uploadedFileName = 'edit_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        // Handle upload untuk web dan mobile
        if (kIsWeb) {
          final bytes = await gambarFile.readAsBytes();
          await client.storage
              .from('produk')
              .uploadBinary(uploadedFileName, bytes,
                  fileOptions: FileOptions(contentType: 'image/$fileExt'));
        } else {
          final bytes = await gambarFile.readAsBytes();
          await client.storage
              .from('produk')
              .uploadBinary(uploadedFileName, bytes);
        }

        gambarUrl = client.storage
            .from('produk')
            .getPublicUrl(uploadedFileName);
      } else if (hapusGambar) {
        gambarUrl = null;
      }

      // === STEP 4: UPDATE PRODUK ===
      final Map<String, dynamic> updates = {
        'nama': nama,
        'kategori': (kategori.index + 1).toString(),
        'kelangkaan': (kelangkaan.index + 1).toString(),
        'harga_beli': hargaBeli,
        'harga_jual': hargaJual,
      };

      // Tambahkan gambar_url hanya jika ada perubahan
      if (gambarFile != null || hapusGambar) {
        updates['gambar_url'] = gambarUrl;
      }

      final response = await client
          .from('produk')
          .update(updates)
          .eq('id', produkId)
          .select()
          .single();

      // === STEP 5: BUAT RIWAYAT STOK JIKA ADA PERUBAHAN STOK ===
      if (stok != stokSebelum) {
        final perbedaanStok = stok - stokSebelum;
        final totalHarga = perbedaanStok * hargaBeliLama;

        await client.from('riwayat_stok').insert({
          'produk_id': produkId,
          'stok_sebelum': stokSebelum,
          'stok_sesudah': stok,
          'total_harga': totalHarga,
          'created_by': client.auth.currentUser?.id ?? 'system',
        });
      }

      return Produk.fromJson(response, stok);
      
    } catch (e) {
      // === ROLLBACK JIKA ADA ERROR ===
      if (uploadedFileName != null) {
        try {
          await client.storage.from('produk').remove([uploadedFileName]);
        } catch (deleteError) {
          print('⚠️ Gagal rollback gambar: $deleteError');
        }
      }

      throw 'Gagal mengedit produk: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }

  Future<void> deleteProduk(String produkId) async {
    try {
      // Ambil info produk untuk hapus gambar
      final produk = await client
          .from('produk')
          .select()
          .eq('id', produkId)
          .single();

      // Hapus gambar dari storage jika ada
      final gambarUrl = produk['gambar_url'];
      if (gambarUrl != null && gambarUrl is String && gambarUrl.isNotEmpty) {
        final urlParts = gambarUrl.split('/');
        final fileName = urlParts.last;
        try {
          await client.storage.from('produk').remove([fileName]);
        } catch (e) {
          print('⚠️ Gagal hapus gambar: $e');
        }
      }

      // Hapus produk (riwayat stok otomatis terhapus karena ON DELETE CASCADE)
      await client
          .from('produk')
          .delete()
          .eq('id', produkId);

    } catch (e) {
      throw 'Gagal menghapus produk: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }
}