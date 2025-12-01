import 'package:flutter/material.dart';
import '../config/app_config.dart';

class PopupKelangkaan extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  final bool useIcon;
  final IconData icon;

  const PopupKelangkaan({
    super.key,
    required this.selected,
    required this.onChanged,
    this.useIcon = true,
    this.icon = Icons.filter_alt_outlined,
  });

  // Mapping: value → label + warna
  Map<String, (String label, Color color)> get _data => {
        "none": ("None", AppColors.abu),
        "1": ("Common", Colors.black),
        "2": ("Uncommon", AppColors.uncommon),
        "3": ("Rare", AppColors.biru),
        "4": ("Epic", AppColors.epic),
        "5": ("Exclusive", AppColors.exclusive),
        "6": ("Legendary", AppColors.legendary),
        "7": ("Mythic", AppColors.mythic),
        "8": ("Secret", AppColors.secret),
      };

  @override
  Widget build(BuildContext context) {
    // menentukan apa teks & warna yang sedang dipilih
    final display = _data[selected ?? "none"]!;
    final displayText = display.$1;
    final displayColor = display.$2;

    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      initialValue: selected,
      onSelected: (value) => onChanged(value == "none" ? null : value),
      icon: useIcon ? Icon(icon) : null,
      child: useIcon
          ? null
          : Container(
              child: Text(
                displayText,
                style: TextStyle(
                  color: displayColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
      itemBuilder: (context) => _data.entries.map((e) {
        return PopupMenuItem(
          value: e.key,
          child: Text(
            e.value.$1,
            style: TextStyle(color: e.value.$2),
          ),
        );
      }).toList(),
    );
  }
}
