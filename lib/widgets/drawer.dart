import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
              // decoration: BoxDecoration(
              //   border: Border(bottom: BorderSide(width: 1))
              // ),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            child: Row(
              children: [
                Image.asset('images/logo.png', width: 100, height: 100),
                const SizedBox(width: 12),
                Image.asset('images/FishPiece.png', height: 30),
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
                  title: "Beranda",
                  onTap: () => Navigator.pop(context),
                ),

                _buildExpandableMenuItem(
                  icon: Icons.dashboard_outlined,
                  title: "Dashboard",
                  submenu: {
                    "Dashboard Penjualan": () {
                      Navigator.pop(context);
                      // Navigasi ke Dashboard Penjualan
                    },
                    "Dashboard Inventori": () {
                      Navigator.pop(context);
                      // Navigasi ke Dashboard Inventori
                    },
                  },
                ),

                _buildMenuItem(
                  icon: Icons.inventory_2_outlined,
                  title: "Produk",
                  onTap: () {
                    // Navigate to Produk
                  },
                ),

                _buildMenuItem(
                  icon: Icons.people_outline,
                  title: "Pelanggan",
                  onTap: () {
                    // Navigate to Pelanggan
                  },
                ),

                _buildExpandableMenuItem(
                  icon: Icons.admin_panel_settings_outlined,
                  title: "Admin Panel",
                  submenu: {
                    "User Management": () {
                      Navigator.pop(context);
                      // Navigasi ke User Management
                    },
                    "System Logs": () {
                      Navigator.pop(context);
                      // Navigasi ke System Logs
                    },
                  },
                ),

                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: "Pengaturan",
                  onTap: () {
                    // Navigate to Pengaturan
                  },
                ),
              ],
            ),
          ),

          // Logout di bagian bawah
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Aksi logout
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

  // Menu dengan submenu (expandable)
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
            onTap: entry.value, // Navigasi hanya di submenu
          ),
        );
      }).toList(),
    );
  }
}
