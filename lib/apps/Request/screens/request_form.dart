import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pageturn_mobile/apps/Request/screens/request_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// TODO: Impor drawer yang sudah dibuat sebelumnya

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _author = "";
  String _description = "";
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Create Your Request',
          ),
        ),
        backgroundColor: Color.fromARGB(255, 192, 108, 52),
        foregroundColor: Colors.white,
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Book Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _title = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Judul buku tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Author",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    // TODO: Tambahkan variabel yang sesuai
                    onChanged: (String? value) {
                      setState(() {
                        _author = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Nama penulis tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText:
                          "Genre, Which series, Publication year, Language, etc",
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        // TODO: Tambahkan variabel yang sesuai
                        _description = value!;
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 192, 108, 52)),
                      ),
                      child: const Text(
                        "SEND",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          final response = await request.postJson(
                              "http://localhost:8000/request_buku/create-request-flutter/",
                              jsonEncode(<String, String>{
                                'title': _title,
                                'author': _author,
                                'description': _description,
                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }));
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Your request has been successfully sent"),
                            ));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("An error occurred, please try again"),
                            ));
                          }
                        }
                        // if (_formKey.currentState!.validate()) {
                        //   showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: const Text(
                        //             'Your request has been successfully sent'),
                        //         content: SingleChildScrollView(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Text('Judul: $_title'),
                        //               Text('Penulis: $_author'),
                        //               Text('Deskripsi: $_description'),
                        //             ],
                        //           ),
                        //         ),
                        //         actions: [
                        //           TextButton(
                        //             child: const Text('SEND'),
                        //             onPressed: () {
                        //               Navigator.pop(context);
                        //             },
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // }
                        // _formKey.currentState!.reset();
                      },
                    ),
                  ),
                ),
              ])),
        ),
      ),
    );
  }
}
