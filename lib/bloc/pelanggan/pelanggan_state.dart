import 'package:fish_it_kasir/models/pelanggan.dart';

abstract class PelangganState {}

class PelangganInitial extends PelangganState {}

class PelangganLoading extends PelangganState {}

class PelangganLoaded extends PelangganState {
  final List<Pelanggan> pelangganList;
  PelangganLoaded(this.pelangganList);
}

class PelangganError extends PelangganState {
  final String message;
  PelangganError(this.message);
}

// STATES KHUSUS UNTUK ADD PELANGGAN
class PelangganAddInProgress extends PelangganState {}

class PelangganAddSuccess extends PelangganState {
  final String message;
  PelangganAddSuccess(this.message);
}

class PelangganAddFailure extends PelangganState {
  final String message;
  PelangganAddFailure(this.message);
}

// STATES KHUSUS UNTUK EDIT PELANGGAN
class PelangganEditInProgress extends PelangganState {}

class PelangganEditSuccess extends PelangganState {
  final String message;
  final Pelanggan pelanggan;
  PelangganEditSuccess(this.message, this.pelanggan);
}

class PelangganEditFailure extends PelangganState {
  final String message;
  PelangganEditFailure(this.message);
}

// STATES KHUSUS UNTUK DELETE PELANGGAN
class PelangganDeleteInProgress extends PelangganState {}

class PelangganDeleteSuccess extends PelangganState {
  final String message;
  final String pelangganId;
  PelangganDeleteSuccess(this.message, this.pelangganId);
}

class PelangganDeleteFailure extends PelangganState {
  final String message;
  PelangganDeleteFailure(this.message);
}