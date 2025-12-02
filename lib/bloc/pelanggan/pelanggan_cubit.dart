// lib/bloc/pelanggan/pelanggan_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fish_it_kasir/services/pelanggan.dart';
import 'pelanggan_state.dart';

class PelangganCubit extends Cubit<PelangganState> {
  final PelangganService service;

  PelangganCubit(this.service) : super(PelangganInitial());

  // Load pelanggan
  Future<void> loadPelanggan({bool forceReload = false}) async {
    if (!forceReload && state is PelangganLoaded) return;

    emit(PelangganLoading());
    try {
      final data = await service.getPelanggan();
      emit(PelangganLoaded(data));
    } catch (e) {
      emit(PelangganError(e.toString()));
    }
  }

  // Tambah pelanggan
  Future<void> tambahPelanggan({
    required String nama,
    required String usnRoblox,
    String? noWa,
    required String createdBy,
  }) async {
    emit(PelangganAddInProgress());
    
    try {
      await service.tambahPelanggan(
        nama: nama,
        usnRoblox: usnRoblox,
        noWa: noWa,
        createdBy: createdBy,
      );

      emit(PelangganAddSuccess('Pelanggan "$nama" berhasil ditambahkan'));
      await _silentLoadPelanggan();
      
    } catch (e) {
      emit(PelangganAddFailure(e.toString()));
    }
  }

  // Edit pelanggan
  Future<void> editPelanggan({
    required String pelangganId,
    required String nama,
    required String usnRoblox,
    String? noWa,
    required String updatedBy,
  }) async {
    emit(PelangganEditInProgress());
    
    try {
      final updatedPelanggan = await service.editPelanggan(
        pelangganId: pelangganId,
        nama: nama,
        usnRoblox: usnRoblox,
        noWa: noWa,
        updatedBy: updatedBy,
      );

      emit(PelangganEditSuccess('Pelanggan "$nama" berhasil diperbarui', updatedPelanggan));
      await _silentLoadPelanggan();
      
    } catch (e) {
      emit(PelangganEditFailure(e.toString()));
    }
  }

  // Delete pelanggan
  Future<void> deletePelanggan(String pelangganId) async {
    emit(PelangganDeleteInProgress());
    
    try {
      await service.deletePelanggan(pelangganId);
      emit(PelangganDeleteSuccess('Pelanggan berhasil dihapus', pelangganId));
      await _silentLoadPelanggan();
      
    } catch (e) {
      emit(PelangganDeleteFailure(e.toString()));
    }
  }

  // Helper: Load pelanggan secara silent
  Future<void> _silentLoadPelanggan() async {
    try {
      final data = await service.getPelanggan();
      emit(PelangganLoaded(data));
    } catch (e) {
      print('⚠️ Gagal refresh data pelanggan: $e');
    }
  }
}