import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../config/app_config.dart';

class KategoriFilter extends StatefulWidget {
  final Kategori? kategoriTerpilih;
  final ValueChanged<Kategori?> onKategoriChanged;

  const KategoriFilter({
    super.key,
    required this.kategoriTerpilih,
    required this.onKategoriChanged,
  });

  @override
  State<KategoriFilter> createState() => _KategoriFilterState();
}

class _KategoriFilterState extends State<KategoriFilter> {
  // Format nama kategori untuk display
  String _formatNamaKategori(Kategori kategori) {
    switch (kategori) {
      case Kategori.ikan:
        return 'Ikan';
      case Kategori.joran:
        return 'Joran';
      case Kategori.kapal:
        return 'Kapal';
      case Kategori.item:
        return 'Item';
    }
  }

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Tombol Semua
          Container(
            margin: const EdgeInsets.only(right: 40),
            child: InkWell(
              onTap: () {
                widget.onKategoriChanged(null);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: widget.kategoriTerpilih == null
                          ? AppColors.biru
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Semua',
                  style: font.bodyMedium?.copyWith(
                    fontWeight: widget.kategoriTerpilih == null
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: widget.kategoriTerpilih == null
                        ? AppColors.biru
                        : AppColors.abu,
                  ),
                ),
              ),
            ),
          ),

          // Kategori-kategori lainnya
          ...Kategori.values.map((kategori) {
            final isSelected = widget.kategoriTerpilih == kategori;
            return Container(
              margin: const EdgeInsets.only(right: 40),
              child: InkWell(
                onTap: () {
                  widget.onKategoriChanged(kategori);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? AppColors.biru : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    _formatNamaKategori(kategori),
                    style: font.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.biru
                          : AppColors.abu,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
