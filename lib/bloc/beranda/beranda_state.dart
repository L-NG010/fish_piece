import 'package:equatable/equatable.dart';
import '../../models/produk.dart';

abstract class BerandaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BerandaInitial extends BerandaState {}

class BerandaLoading extends BerandaState {}

class BerandaLoaded extends BerandaState {
  final List<Produk> produk;
  final int cartUpdateCounter; // Tambahkan counter untuk memicu rebuild
  
  BerandaLoaded(this.produk, {this.cartUpdateCounter = 0});

  @override
  List<Object?> get props => [produk, cartUpdateCounter];
}

class BerandaError extends BerandaState {
  final String message;
  final int cartUpdateCounter; // Tambahkan counter untuk memicu rebuild
  
  BerandaError(this.message, {this.cartUpdateCounter = 0});

  @override
  List<Object?> get props => [message, cartUpdateCounter];
}