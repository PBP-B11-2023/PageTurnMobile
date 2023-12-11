import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/pages/add_laporan.dart';
import 'package:pageturn_mobile/apps/laporan_buku_rusak/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PAGETURN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 78, 52, 16),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: const LeftDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Laporan Buku Rusak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
            child: Text(
              'List Buku yang Dipinjam:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Add Laporan
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopFormPage()),
                );
              },
              child: Text('Add Laporan'),
            ),
          ),
        ],
      ),
    );
  }
}
