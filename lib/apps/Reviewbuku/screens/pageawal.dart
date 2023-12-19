// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/Reviewbuku/screens/addreview.dart';
import 'package:pageturn_mobile/apps/Reviewbuku/screens/listreview.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';

class HalamanPertama extends StatelessWidget {
  HalamanPertama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text(
          'PAGETURN',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 52, 16),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Review Buku',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Container(
          //   alignment: Alignment.centerLeft,
          //   padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
          //   child: Text(
          //     'List Buku yang akan direview:',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 20),

          // Add review
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewForm()),
                );
              },
              child: const Text('Add Review'),
            ),
          ),

          // Add Daftar
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewPage()),
                );
              },
              child: const Text('Daftar Review'),
            ),
          ),
        ],
      ),
    );
  }
}
