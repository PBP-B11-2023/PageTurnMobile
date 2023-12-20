// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/Authentication/login.dart';
import 'package:pageturn_mobile/apps/Homepage/menu.dart';
import 'package:pageturn_mobile/apps/Katalog/screens/katalog.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/peminjaman_page.dart';
import 'package:pageturn_mobile/apps/Request/screens/request_page.dart';
import 'package:pageturn_mobile/apps/Reviewbuku/screens/pageawal.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/screens/halaman_awal.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      backgroundColor: const Color(0xFFffecd4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 190, // Set your desired height
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF282626),
              ),
              child: Column(
                children: [
                  SizedBox(height: 35),
                  Image(
                    width: 1000,
                    image: NetworkImage(
                        "https://cdn.discordapp.com/attachments/1145315809846104065/1167315920117575700/page-turn-high-resolution-logo-transparent.png"),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Katalog'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KatalogPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.import_contacts),
            title: const Text('Peminjaman Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PeminjamanPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Review Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanPertama(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Laporan Buku Rusak'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HalamanLaporan(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark_rounded),
            title: const Text('Request Buku'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              try {
                final response =
                    await request.logout("https://pageturn-b11-tk.pbp.cs.ui.ac.id/auth/logout/");

                String message = response["message"];
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginApp()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                  ));
                }
              } catch (e) {
                // Handle any errors here
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Error: $e"),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
