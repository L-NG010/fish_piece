import '../../models/produk.dart';

abstract class ProdukState {}

class ProdukInitial extends ProdukState {}

class ProdukLoading extends ProdukState {}

class ProdukLoaded extends ProdukState {
  final List<Produk> produk;
  ProdukLoaded(this.produk);
}

class ProdukError extends ProdukState {
  final String message;
  ProdukError(this.message);
}

// STATES KHUSUS UNTUK ADD PRODUK
class ProdukAddInProgress extends ProdukState {}

class ProdukAddSuccess extends ProdukState {
  final String message;
  ProdukAddSuccess(this.message);
}

class ProdukAddFailure extends ProdukState {
  final String message;
  ProdukAddFailure(this.message);
}

// STATES KHUSUS UNTUK EDIT PRODUK
class ProdukEditInProgress extends ProdukState {}

class ProdukEditSuccess extends ProdukState {
  final String message;
  final Produk produk;
  ProdukEditSuccess(this.message, this.produk);
}

class ProdukEditFailure extends ProdukState {
  final String message;
  ProdukEditFailure(this.message);
}

// STATES KHUSUS UNTUK DELETE PRODUK
class ProdukDeleteInProgress extends ProdukState {}

class ProdukDeleteSuccess extends ProdukState {
  final String message;
  final String produkId;
  ProdukDeleteSuccess(this.message, this.produkId);
}

class ProdukDeleteFailure extends ProdukState {
  final String message;
  ProdukDeleteFailure(this.message);
}