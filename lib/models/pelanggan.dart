// lib/models/pelanggan.dart
class Pelanggan {
  final int id;
  final String nama;
  final String usnRoblox;
  final String? noWa;
  final int poin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;

  Pelanggan({
    required this.id,
    required this.nama,
    required this.usnRoblox,
    this.noWa,
    required this.poin,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'] as int,
      nama: json['nama'] as String,
      usnRoblox: json['usn_roblox'] as String,
      noWa: json['no_wa'] as String?,
      poin: json['poin'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String,
      updatedBy: json['updated_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'usn_roblox': usnRoblox,
      'no_wa': noWa,
      'poin': poin,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  // Copy dengan method untuk mengupdate
  Pelanggan copyWith({
    int? id,
    String? nama,
    String? usnRoblox,
    String? noWa,
    int? poin,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return Pelanggan(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      usnRoblox: usnRoblox ?? this.usnRoblox,
      noWa: noWa ?? this.noWa,
      poin: poin ?? this.poin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}