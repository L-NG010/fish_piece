enum Kategori { ikan, joran, kapal, item }
enum Kelangkaan { common, uncommon, rare, epic, exclusive, legendary, mythic, secret }

Kategori kategoriFromInt(int value) {
  final index = value - 1;
  return (index >= 0 && index < Kategori.values.length)
      ? Kategori.values[index]
      : Kategori.values.first;
}

Kelangkaan kelangkaanFromInt(int value) {
  final index = value - 1;
  return (index >= 0 && index < Kelangkaan.values.length)
      ? Kelangkaan.values[index]
      : Kelangkaan.values.first;
}


class Produk {
  final int id;
  final String nama;
  final Kategori kategori;
  final Kelangkaan kelangkaan;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final String? gambarUrl;

  Produk({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.kelangkaan,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
    this.gambarUrl,
  });

  factory Produk.fromJson(Map<String, dynamic> json, int stokTerbaru) {
    return Produk(
      id: json['id'],
      nama: json['nama'],
      kategori: kategoriFromInt(int.parse(json['kategori'].toString())),
      kelangkaan: kelangkaanFromInt(int.parse(json['kelangkaan'].toString())),
      hargaBeli: double.parse(json['harga_beli'].toString()),
      hargaJual: double.parse(json['harga_jual'].toString()),
      stok: stokTerbaru,
      gambarUrl: json['gambar_url'],
    );
  }
}
  