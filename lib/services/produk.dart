import 'package:supabase_flutter/supabase_flutter.dart';
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
            ? riwayat.first['stok_sesudah']
            : 0;
        // Karena struktur data yang dikembalikan Supabase tetap berupa list (array) meskipun isinya hanya satu elemen

        result.add(Produk.fromJson(item, stokTerbaru));
      }
      return result;
    } catch (error) {
      throw Exception('Gagal mengambil data produk: $error');
    }
  }
}
