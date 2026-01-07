import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard.dart';

class DashboardService{
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<int> customerCount() async {
    try {
      final response = await _supabase
      .from('pelanggan')
      .select('id');
      
      return response.length;
    } catch (e) {
      throw "Gagal mengambil data pelanggan: $e";
    }
  }

  Future<int> stokCount() async {
    try {
      final response = await _supabase
          .from('stok_terbaru_per_produk')
          .select('stok_sesudah');

      int totalStok = 0;
      for (final item in response) {
        totalStok += (item['stok_sesudah'] as int);
      }

      return totalStok;
    } catch (e) {
      throw "Gagal mengambil data stok: $e";
    }
  }

  Future<Dashboard> getDashboardData() async{
    try {
      final customerCount = await this.customerCount();
      final stokCount = await this.stokCount();
      
      return Dashboard(
        customerCount: customerCount,
        stok: stokCount,
      );
    } catch (e) {
      throw "Gagal mengambil data dashboard: $e";
    }
  }
}