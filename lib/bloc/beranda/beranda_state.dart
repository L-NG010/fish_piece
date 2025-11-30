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
  BerandaLoaded(this.produk);

  @override
  List<Object?> get props => [produk];
}

class BerandaError extends BerandaState {
  final String message;
  BerandaError(this.message);

  @override
  List<Object?> get props => [message];
}
