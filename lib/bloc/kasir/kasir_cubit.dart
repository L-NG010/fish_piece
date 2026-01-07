import 'package:flutter_bloc/flutter_bloc.dart';
import 'kasir_state.dart';
import '../../models/produk.dart';

class KasirCubit extends Cubit<KasirState> {
  KasirCubit() : super(KasirInitial());

  void addToCart(Produk produk, int quantity) {
    final currentState = state;
    List<Map<String, dynamic>> cartItems = [];
    
    if (currentState is KasirLoaded) {
      cartItems = List.from(currentState.cartItems);
    }
    
    // Cek apakah produk sudah ada di keranjang
    final existingItemIndex = cartItems.indexWhere((item) => item['id'] == produk.id);
    
    if (existingItemIndex != -1) {
      // Jika sudah ada, tambahkan kuantitasnya
      cartItems[existingItemIndex]['quantity'] += quantity;
    } else {
      // Jika belum ada, tambahkan sebagai item baru
      cartItems.add({
        'id': produk.id,
        'nama': produk.nama,
        'harga': produk.hargaJual,
        'quantity': quantity,
      });
    }
    
    emit(KasirLoaded(cartItems));
  }

  void removeFromCart(int productId) {
    final currentState = state;
    List<Map<String, dynamic>> cartItems = [];
    
    if (currentState is KasirLoaded) {
      cartItems = List.from(currentState.cartItems);
    }
    
    cartItems.removeWhere((item) => item['id'] == productId);
    emit(KasirLoaded(cartItems));
  }

  void increaseQuantity(int productId) {
    final currentState = state;
    List<Map<String, dynamic>> cartItems = [];
    
    if (currentState is KasirLoaded) {
      cartItems = List.from(currentState.cartItems);
    }
    
    final itemIndex = cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      cartItems[itemIndex]['quantity'] += 1;
      emit(KasirLoaded(cartItems));
    }
  }

  void decreaseQuantity(int productId) {
    final currentState = state;
    List<Map<String, dynamic>> cartItems = [];
    
    if (currentState is KasirLoaded) {
      cartItems = List.from(currentState.cartItems);
    }
    
    final itemIndex = cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      if (cartItems[itemIndex]['quantity'] > 1) {
        cartItems[itemIndex]['quantity'] -= 1;
      } else {
        // Jika kuantitas hanya 1, hapus item dari keranjang
        cartItems.removeAt(itemIndex);
      }
      emit(KasirLoaded(cartItems));
    }
  }

  void clearCart() {
    emit(KasirLoaded([]));
  }

  double getTotalHarga() {
    final currentState = state;
    if (currentState is KasirLoaded) {
      return currentState.cartItems.fold(0, (sum, item) => sum + (item['harga'] * item['quantity']));
    }
    return 0.0;
  }
}