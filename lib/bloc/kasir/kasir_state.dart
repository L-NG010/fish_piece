import 'package:equatable/equatable.dart';

abstract class KasirState extends Equatable {
  @override
  List<Object?> get props => [];
}

class KasirInitial extends KasirState {}

class KasirLoading extends KasirState {}

class KasirLoaded extends KasirState {
  final List<Map<String, dynamic>> cartItems;
  
  KasirLoaded(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class KasirError extends KasirState {
  final String message;
  
  KasirError(this.message);

  @override
  List<Object?> get props => [message];
}