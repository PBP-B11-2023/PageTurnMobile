// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:pageturn_mobile/apps/laporan_buku_rusak/models/laporan_buku.dart';
// import 'dart:convert';
// import 'package:pageturn_mobile/components/left_drawer.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';


// class ProductPage extends StatefulWidget {
//     const ProductPage({Key? key}) : super(key: key);

//     @override
//     _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
// Future<List<Laporan>> fetchProduct(request) async {
//     var response = await request.get('http://localhost:8000/laporan_buku_rusak/json/');
//         // headers: {"Content-Type": "application/json"},

   

//     // melakukan konversi data json menjadi object Product
//     List<Laporan> list_product = [];
//     for (var d in response) {
//         if (d != null) {
//             list_product.add(Laporan.fromJson(d));
//         }
//     }
//     return list_product;
// }

// @override
// Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//         appBar: AppBar(
//         title: const Text('Product'),
//         ),
//         drawer: const LeftDrawer(),
//         body: FutureBuilder(
//             future: fetchProduct(request),
//             builder: (context, AsyncSnapshot snapshot) {
//                 if (snapshot.data == null) {
//                     return const Center(child: CircularProgressIndicator());
//                 } else {
//                     if (!snapshot.hasData) {
//                     return const Column(
//                         children: [
//                         Text(
//                             "Tidak ada data produk.",
//                             style:
//                                 TextStyle(color: Color(0xff59A5D8), fontSize: 20),
//                         ),
//                         SizedBox(height: 8),
//                         ],
//                     );
//                 } else {
//                     return ListView.builder(
//                         itemCount: snapshot.data!.length,
//                         itemBuilder: (_, index) => Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 12),
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                        Text(
//                                     "${snapshot.data![index].fields.name}",
//                                     style: const TextStyle(
//                                         fontSize: 18.0,
//                                         fontWeight: FontWeight.bold,
//                                     ),
//                                     ),

//                                     // const SizedBox(height: 10),
//                                     // Text("${snapshot.data![index].fields.price}"),
//                                     const SizedBox(height: 10),
//                                     Text(
//                                         "${snapshot.data![index].fields.description}")
//                                 ],
//                                 ),
//                             ));
//                     }
//                 }
//             }));
//     }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageturn_mobile/apps/laporan_buku_rusak/models/laporan_buku.dart';
import 'dart:convert';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future<List<Laporan>> fetchProduct(request) async {
    var response = await request.get('http://localhost:8000/laporan_buku_rusak/json/');
    // headers: {"Content-Type": "application/json"},

    // melakukan konversi data json menjadi object Product
    List<Laporan> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Laporan.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text(
          'Daftar Laporan Buku Rusak',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF282626),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada data produk.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text(
                  //     "Hai, ${request.user.username}",
                  //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Berikut ini adalah laporan Anda:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data![index].fields.name}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("${snapshot.data![index].fields.description}")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
