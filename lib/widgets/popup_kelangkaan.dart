import 'package:flutter/material.dart';
import '../config/app_config.dart';

class PopupKelangkaan extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;

  /// apakah tampil sebagai tombol icon (untuk AppBar)
  final bool useIcon;

  /// icon kustom untuk AppBar
  final IconData icon;

  const PopupKelangkaan({
    super.key,
    required this.selected,
    required this.onChanged,
    this.useIcon = true,
    this.icon = Icons.filter_alt_outlined, // default jika tidak diisi
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      initialValue: selected,
      onSelected: (value) => onChanged(value == "none" ? null : value),
      icon: useIcon
          ? Icon(icon)
          : null,
      child: useIcon
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(selected ?? "Kelangkaan"),
            ),
      itemBuilder: (context) => [
        PopupMenuItem(value: "none", child: Text("None", style: TextStyle(color: AppColors.abu),),),
        const PopupMenuItem(value: "1", child: Text("Common", style: TextStyle(color: Colors.black),),),
        const PopupMenuItem(value: "2", child: Text("Uncommon", style: TextStyle(color: AppColors.uncommon),)),
        const PopupMenuItem(value: "3", child: Text("Rare", style: TextStyle(color: AppColors.biru),)),
        const PopupMenuItem(value: "4", child: Text("Epic", style: TextStyle(color: AppColors.epic),)),
        const PopupMenuItem(value: "5", child: Text("Exclusive", style: TextStyle(color: AppColors.exclusive),)),
        const PopupMenuItem(value: "6", child: Text("Legendary", style: TextStyle(color: AppColors.legendary),)),
        const PopupMenuItem(value: "7", child: Text("Mythic", style: TextStyle(color: AppColors.mythic),)),
        const PopupMenuItem(value: "8", child: Text("Secret", style: TextStyle(color: AppColors.secret),)),
      ],
    );
  }
}
