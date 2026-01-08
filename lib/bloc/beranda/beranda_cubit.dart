import 'package:flutter_bloc/flutter_bloc.dart';
import 'beranda_state.dart';
import '../../services/produk.dart';
import '../../models/produk.dart';

class BerandaCubit extends Cubit<BerandaState> {
  final ProdukService service;
  int _cartUpdateCounter = 0; // Counter untuk memicu rebuild

  BerandaCubit(this.service) : super(BerandaInitial());

  Future<void> loadProduk() async {
    if (state is BerandaLoaded) return;  // Cegah fetch ulang

    emit(BerandaLoading());
    try {
      final data = await service.getProduk();
      emit(BerandaLoaded(data, cartUpdateCounter: _cartUpdateCounter));
    } catch (e) { 
      emit(BerandaError("Gagal memuat data: $e", cartUpdateCounter: _cartUpdateCounter));
    }
  }

  Future<void> refresh() async {
    emit(BerandaLoading());
    try {
      final data = await service.getProduk();
      emit(BerandaLoaded(data, cartUpdateCounter: _cartUpdateCounter));
    } catch (e) {
      emit(BerandaError("Gagal memperbarui data: $e", cartUpdateCounter: _cartUpdateCounter));
    }
  }

  // Fungsi untuk mengelola keranjang
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Produk produk, int quantity) {
    // Cek apakah produk sudah ada di keranjang
    final existingItemIndex = _cartItems.indexWhere((item) => item['id'] == produk.id);
    
    int newQuantity = quantity;
    if (existingItemIndex != -1) {
      // Jika sudah ada, tambahkan kuantitasnya
      newQuantity = _cartItems[existingItemIndex]['quantity'] + quantity;
    }
    
    // Validasi stok sebelum menambahkan ke keranjang
    if (newQuantity > produk.stok) {
      // Tampilkan error atau tidak lakukan apa-apa
      return;
    }
    
    if (existingItemIndex != -1) {
      // Update kuantitas item yang sudah ada
      _cartItems[existingItemIndex]['quantity'] = newQuantity;
    } else {
      // Tambahkan sebagai item baru
      _cartItems.add({
        'id': produk.id,
        'nama': produk.nama,
        'harga': produk.hargaJual,
        'quantity': quantity,
        'stok': produk.stok, // Simpan stok produk untuk validasi
      });
    }
    // Update state dengan counter baru
    _emitCurrentState();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    // Update state dengan counter baru
    _emitCurrentState();
  }

  void increaseQuantity(int productId) {
    final itemIndex = _cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      // Ambil produk dari state untuk mendapatkan informasi stok
      if (state is BerandaLoaded) {
        final produkList = (state as BerandaLoaded).produk;
        final produk = produkList.firstWhere((p) => p.id == productId, orElse: () => produkList.first);
        
        // Cek apakah kuantitas yang diminta melebihi stok
        if (_cartItems[itemIndex]['quantity'] < produk.stok) {
          _cartItems[itemIndex]['quantity'] += 1;
          // Update state dengan counter baru
          _emitCurrentState();
        }
      } else {
        // Jika state bukan BerandaLoaded, kita tetap tambahkan kuantitas jika memungkinkan
        // Tapi tanpa validasi stok yang akurat
        _cartItems[itemIndex]['quantity'] += 1;
        _emitCurrentState();
      }
    }
  }

  void decreaseQuantity(int productId) {
    final itemIndex = _cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      if (_cartItems[itemIndex]['quantity'] > 1) {
        _cartItems[itemIndex]['quantity'] -= 1;
      } else {
        // Jika kuantitas hanya 1, hapus item dari keranjang
        _cartItems.removeAt(itemIndex);
      }
      // Update state dengan counter baru
      _emitCurrentState();
    }
  }

  void clearCart() {
    _cartItems.clear();
    // Update state dengan counter baru
    _emitCurrentState();
  }

  double getTotalHarga() {
    return _cartItems.fold(0, (sum, item) => sum + (item['harga'] * item['quantity']));
  }
  
  int getTotalItems() {
    return _cartItems.fold(0, (int sum, item) => sum + (item['quantity'] as int));
  }
  
  int getQuantityById(int productId) {
    final itemIndex = _cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      return _cartItems[itemIndex]['quantity'];
    }
    return 0;
  }
  
  // Helper method untuk meng-update state saat ini dengan counter baru
  void _emitCurrentState() {
    _cartUpdateCounter++; // Naikkan counter untuk memicu rebuild
    final currentState = state;
    if (currentState is BerandaLoaded) {
      // Buat state baru dengan counter yang diperbarui
      emit(BerandaLoaded(currentState.produk, cartUpdateCounter: _cartUpdateCounter));
    } else if (currentState is BerandaError) {
      emit(BerandaError(currentState.message, cartUpdateCounter: _cartUpdateCounter));
    } else {
      // Untuk state lainnya, kita tetap gunakan counter
      if (currentState is BerandaInitial) {
        emit(BerandaInitial());
      } else if (currentState is BerandaLoading) {
        emit(BerandaLoading());
      }
    }
  }
}