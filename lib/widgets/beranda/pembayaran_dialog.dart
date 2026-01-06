import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/beranda/struk.dart';
import 'package:flutter/material.dart';

class DialogPembayaran extends StatelessWidget {
  const DialogPembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pembayaran",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 4),
                    Text("L Nata"),
                  ],
                ),
              ],
            ),

            SizedBox(height: 25),

            // HARGA
            Text("Harga"),
            SizedBox(height: 5),
            _textBox("145.000"),

            SizedBox(height: 18),

            // TUNAI
            Text("Tunai"),
            SizedBox(height: 5),
            _textBox("150.000"),

            SizedBox(height: 18),

            // KEMBALIAN
            Text("Kembalian"),
            SizedBox(height: 5),
            _textBox("5.000"),

            SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: _button(
                    label: "Batal",
                    color: AppColors.biru,
                    onTap: () => Navigator.popUntil(context,(route) => route.isFirst),
                  ),
                ),
                SizedBox(width: 12), // Jarak antar tombol
                Expanded(
                  child: _button(
                    label: "Bayar",
                    color: AppColors.biru,
                    onTap: () {
                      showDialog(context: context, builder: (builder)=> PopUpStruk());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textBox(String text) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: text),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _button({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label,
        style: TextStyle(
          color: Colors.white
        ),
        ),
      ),
    );
  }
}
