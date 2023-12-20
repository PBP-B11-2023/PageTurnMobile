import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pageturn_mobile/apps/Request/screens/request_form.dart';
import 'package:pageturn_mobile/apps/Request/models/request.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  Future<List<Request>> fetchRequest(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url =
        Uri.parse('http://localhost:8000/request_buku/show_request_json/');
    var response = await request.get(
      url.toString(),
      // headers: {"Content-Type": "application/json"},
    );
    // melakukan decode response menjadi bentuk json
    // var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Request> list_request = [];
    for (var d in response) {
      if (d != null) {
        list_request.add(Request.fromJson(d));
      }
    }
    return list_request;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Request'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchRequest(context.read<CookieRequest>()),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "This list has no requests",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            color: Color(0xffc06c34),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data![index].fields.title}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("${snapshot.data![index].fields.author}"),
                                const SizedBox(height: 10),
                                Text(
                                    "${snapshot.data![index].fields.description}")
                              ],
                            ),
                          ),
                        ));
              }
            }
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequestForm()),
                );
              },
              child: const Text('Create Book Request'),
            ),
          ],
        ),
      ),
    );
  }
}
