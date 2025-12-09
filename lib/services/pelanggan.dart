// lib/services/pelanggan_service.dart
import 'package:fish_it_kasir/models/pelanggan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get semua pelanggan
  Future<List<Pelanggan>> getPelanggan() async {
    try {
      final response = await _supabase
          .from('pelanggan')
          .select()
          .order('nama', ascending: true);

      if (response.isEmpty) return [];

      return List<Pelanggan>.from(
        response.map((json) => Pelanggan.fromJson(json)),
      );
    } catch (e) {
      throw 'Gagal mengambil data pelanggan: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }

  // Tambah pelanggan
  Future<Pelanggan> tambahPelanggan({
    required String nama,
    required String usnRoblox,
    String? noWa,
  }) async {
    try {
      // Validasi username Roblox unik
      final existingPelanggan = await _supabase
          .from('pelanggan')
          .select()
          .eq('usn_roblox', usnRoblox)
          .maybeSingle();

      if (existingPelanggan != null) {
        throw 'Username Roblox "$usnRoblox" sudah terdaftar. Gunakan username lain.';
      }

      final createdBy = _supabase.auth.currentUser?.id ?? 'system';
      final response = await _supabase
          .from('pelanggan')
          .insert({
            'nama': nama,
            'usn_roblox': usnRoblox,
            'no_wa': noWa,
            'poin': 0,
            'created_by': createdBy,
          })
          .select()
          .single();

      return Pelanggan.fromJson(response);
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        throw 'Username Roblox "$usnRoblox" sudah terdaftar. Gunakan username lain.';
      }
      throw 'Gagal menambahkan pelanggan: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }

  // Edit pelanggan
  Future<Pelanggan> editPelanggan({
    required String pelangganId,
    required String nama,
    required String usnRoblox,
    String? noWa,
  }) async {
    try {
      // Validasi username Roblox unik (kecuali untuk pelanggan ini sendiri)
      final existingPelanggan = await _supabase
          .from('pelanggan')
          .select()
          .eq('usn_roblox', usnRoblox)
          .neq('id', pelangganId)
          .maybeSingle();

      if (existingPelanggan != null) {
        throw 'Username Roblox "$usnRoblox" sudah terdaftar. Gunakan username lain.';
      }

      final updatedBy = _supabase.auth.currentUser?.id ?? 'system';
      final response = await _supabase
          .from('pelanggan')
          .update({
            'nama': nama,
            'usn_roblox': usnRoblox,
            'no_wa': noWa,
            'updated_by': updatedBy,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', pelangganId)
          .select()
          .single();

      return Pelanggan.fromJson(response);
    } catch (e) {
      if (e.toString().contains('duplicate key')) {
        throw 'Username Roblox "$usnRoblox" sudah terdaftar. Gunakan username lain.';
      }
      throw 'Gagal mengedit pelanggan: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }

  // Delete pelanggan
  Future<void> deletePelanggan(String pelangganId) async {
    try {
      await _supabase
          .from('pelanggan')
          .delete()
          .eq('id', pelangganId);
    } catch (e) {
      throw 'Gagal menghapus pelanggan: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }

  // Get stats pelanggan
  Future<Map<String, dynamic>> getPelangganStats(int pelangganId) async {
    try {
      final response = await _supabase
          .from('penjualan')
          .select('total_harga, diskon')
          .eq('pelanggan_id', pelangganId);

      double totalBelanja = 0;
      int totalPembelian = 0;

      if (response.isNotEmpty) {
        totalPembelian = response.length;
        for (var penjualan in response) {
          totalBelanja += (penjualan['total_harga'] as num).toDouble();
        }
      }

      return {
        'total_belanja': totalBelanja,
        'total_pembelian': totalPembelian,
      };
    } catch (e) {
      return {
        'total_belanja': 0.0,
        'total_pembelian': 0,
      };
    }
  }

  // Get all customers with their statistics
  Future<List<Map<String, dynamic>>> getAllPelangganWithStats() async {
    try {
      final pelangganList = await getPelanggan();
      List<Map<String, dynamic>> result = [];

      for (var pelanggan in pelangganList) {
        final stats = await getPelangganStats(pelanggan.id);
        result.add({
          'pelanggan': pelanggan,
          'total_belanja': stats['total_belanja'],
          'total_pembelian': stats['total_pembelian'],
        });
      }

      return result;
    } catch (e) {
      throw 'Gagal mengambil data pelanggan dengan statistik: ${e.toString().replaceAll("Exception: ", "")}';
    }
  }
}