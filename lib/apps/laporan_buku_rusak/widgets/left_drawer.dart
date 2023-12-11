//INI CUMAN BUAT TEST MODUL LAPORAN BUKU RUSAK


import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/pages/add_laporan.dart';
// import 'package:PAGETURNMOBILE/apps/laporan_buku_rusak/pages/add_laporan.dart';
// TODO: Impor halaman ShopFormPage jika sudah dibuat

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // const DrawerHeader(
          //   // TODO: Bagian drawer header
          // ),
          // TODO: Bagian routing
          ListTile(
          title: const Text('Laporan', style: TextStyle(color: Colors.white)),
          leading: const Icon(Icons.event, color: Colors.white),
          onTap: () {
            // Route menu ke counter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ShopFormPage()),
            );
          },
        ),
        Divider(color: Colors.white),
        ],
      ),
    );
  }
}