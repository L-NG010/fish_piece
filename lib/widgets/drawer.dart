import 'package:fish_it_kasir/bloc/auth/auth_cubit.dart';
import 'package:fish_it_kasir/screens/kelola_petugas.dart';
import 'package:fish_it_kasir/screens/laporan.dart';
import 'package:fish_it_kasir/screens/login.dart';
import 'package:fish_it_kasir/screens/pelanggan.dart';
import 'package:fish_it_kasir/screens/produk.dart';
import 'package:fish_it_kasir/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/beranda.dart';
import '../screens/dashboard.dart';
import '../screens/pengaturan.dart';
import 'package:easy_localization/easy_localization.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _navigateWithoutAnimation(BuildContext context, Widget page) {
    Navigator.pop(context); // tutup drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            child: Row(
              children: [
                Image.asset('assets/images/logo.png', width: 100, height: 100),
                const SizedBox(width: 12),
                Image.asset('assets/images/FishPiece.png', height: 30),
              ],
            ),
          ),
          const Divider(height: 1),

          // Menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home_outlined,
                  title: "beranda.title".tr(),
                  onTap: () =>
                      _navigateWithoutAnimation(context, BerandaScreen()),
                ),

                _buildExpandableMenuItem(
                  icon: Icons.dashboard_outlined,
                  title: "dashboard.title".tr(),
                  submenu: {
                    "dashboard.main".tr(): () {
                      _navigateWithoutAnimation(
                        context,
                        const DashboardScreen(),
                      );
                    },
                    "laporan.title".tr(): () {
                      _navigateWithoutAnimation(context, const LaporanScreen());
                    },
                  },
                ),

                _buildMenuItem(
                  icon: Icons.inventory_2_outlined,
                  title: "produk.title".tr(),
                  onTap: () {
                    _navigateWithoutAnimation(context, ProdukScreen());
                  },
                ),

                _buildMenuItem(
                  icon: Icons.people_outline,
                  title: "pelanggan.title".tr(),
                  onTap: () {
                    _navigateWithoutAnimation(context, PelangganScreen());
                  },
                ),

                _buildExpandableMenuItem(
                  icon: Icons.admin_panel_settings_outlined,
                  title: "admin_panel.title".tr(),
                  submenu: {
                    "kelola_petugas.title".tr(): () {
                      _navigateWithoutAnimation(context, KelolaPetugasScreen());
                    },
                    "register.title".tr(): () {
                      _navigateWithoutAnimation(context, RegisterScreen());
                    },
                  },
                ),

                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: "settings.title".tr(),
                  onTap: () {
                    _navigateWithoutAnimation(context, PengaturanScreen());
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              "auth.logout".tr(),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => _LogoutConfirmationDialog(
                  onConfirm: () async {
                    // 1. Tutup dialog
                    Navigator.pop(dialogContext);

                    // 2. Logout dari Supabase
                    await context.read<AuthCubit>().logout();

                    // 3. Langsung navigate ke login
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Menu normal
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      onTap: onTap,
    );
  }

  // Menu expandable
  Widget _buildExpandableMenuItem({
    required IconData icon,
    required String title,
    required Map<String, VoidCallback> submenu,
  }) {
    return ExpansionTile(
      leading: Icon(icon, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      children: submenu.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(left: 40),
          child: ListTile(
            title: Text(entry.key, style: const TextStyle(fontSize: 14)),
            onTap: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

class _LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("auth.logout_confirm_title".tr()),
      content: Text("auth.logout_confirm_message".tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("auth.cancel".tr()),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text("auth.logout".tr(), style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
