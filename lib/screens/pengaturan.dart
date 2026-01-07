import 'package:fish_it_kasir/config/app_config.dart';
import 'package:fish_it_kasir/widgets/appbar.dart';
import 'package:fish_it_kasir/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  late String _selectedLanguage;
  final TextEditingController _minimalStokController = TextEditingController(
    text: "10",
  );

  @override
  void initState() {
    super.initState();
    _selectedLanguage = '';
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedLanguage.isEmpty) {
      final currentLocale = context.locale;
      _selectedLanguage = currentLocale.languageCode == 'id' ? 'Indonesia' : 'English';
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: CustomAppBar(title: "settings.title".tr(), actions: []),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "settings.language".tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              items: [
                DropdownMenuItem(
                  value: "Indonesia", 
                  child: Text("settings.indonesian".tr())
                ),
                DropdownMenuItem(
                  value: "English", 
                  child: Text("settings.english".tr())
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "settings.min_stock_limit".tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _minimalStokController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "settings.min_stock_hint".tr(),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final languageCode = _selectedLanguage == 'Indonesia' ? 'id' : 'en';
                    
                    try {
                      await EasyLocalization.of(context)!.setLocale(Locale(languageCode));
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("settings.save_success".tr()),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      print('Error setting locale: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error changing language: $e'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.biru,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "settings.save".tr(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}