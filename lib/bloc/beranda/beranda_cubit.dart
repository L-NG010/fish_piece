import 'package:flutter_bloc/flutter_bloc.dart';
import 'beranda_state.dart';
import '../../services/produk.dart';

class BerandaCubit extends Cubit<BerandaState> {
  final ProdukService service;

  BerandaCubit(this.service) : super(BerandaInitial());

  Future<void> loadProduk() async {
    if (state is BerandaLoaded) return;  // Cegah fetch ulang

    emit(BerandaLoading());
    try {
      final data = await service.getProduk();
      emit(BerandaLoaded(data));
    } catch (e) { 
      emit(BerandaError("Gagal memuat data: $e"));
    }
  }

  Future<void> refresh() async {
    emit(BerandaLoading());
    try {
      final data = await service.getProduk();
      emit(BerandaLoaded(data));
    } catch (e) {
      emit(BerandaError("Gagal memperbarui data: $e"));
    }
  }
}
