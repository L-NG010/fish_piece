import 'package:flutter/material.dart';

class TopProdukCard extends StatelessWidget {
  const TopProdukCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: const Text(
                'Top Produk',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Table Header
            _buildTableRow(
              no: 'No',
              nama: 'Nama',
              jenis: 'Jenis',
              total: 'Total',
              isHeader: true,
            ),
            
            const Divider(height: 24, thickness: 1),
            
            // Table Content
            _buildTableRow(
              no: '1',
              nama: 'Gran Maja',
              jenis: 'Ikan',
              total: '12',
            ),
            const SizedBox(height: 12),
            _buildTableRow(
              no: '2',
              nama: 'Gran Maja',
              jenis: 'Ikan',
              total: '12',
            ),
            const SizedBox(height: 12),
            _buildTableRow(
              no: '3',
              nama: 'Produk Lain',
              jenis: 'Ayam',
              total: '8',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow({
    required String no,
    required String nama,
    required String jenis,
    required String total,
    bool isHeader = false,
  }) {
    final textStyle = TextStyle(
      fontSize: isHeader ? 14 : 13,
      fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
      color: isHeader ? Colors.black87 : Colors.black54,
    );

    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(no, style: textStyle),
        ),
        Expanded(
          flex: 3,
          child: Text(nama, style: textStyle),
        ),
        Expanded(
          flex: 2,
          child: Text(jenis, style: textStyle),
        ),
        SizedBox(
          width: 40,
          child: Text(
            total,
            style: textStyle,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}