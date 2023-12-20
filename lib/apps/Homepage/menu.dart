// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pageturn_mobile/components/left_drawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> favoriteBooks = [];
  int currentBookIndex = 0;

  @override
  void initState() {
    fetchFavoriteBooks();
    super.initState();
  }

  Future<void> fetchFavoriteBooks() async {
    final response = await http.get(
      Uri.parse(
          'https://pageturn-b11-tk.pbp.cs.ui.ac.id/get_favourite_books/'), // Replace with your Django API endpoint
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        favoriteBooks =
            List<Map<String, dynamic>>.from(data['favourite_books']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load, please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void nextBook() {
    setState(() {
      currentBookIndex = (currentBookIndex + 1) % favoriteBooks.length;
    });
  }

  void prevBook() {
    setState(() {
      currentBookIndex =
          (currentBookIndex + favoriteBooks.length - 1) % favoriteBooks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF010101),
        foregroundColor: Colors.white,
        title: const Image(
          width: 130,
          image: NetworkImage(
              "https://cdn.discordapp.com/attachments/1145315809846104065/1167315920117575700/page-turn-high-resolution-logo-transparent.png"),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF010101), // Set the background color
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9, // Set the aspect ratio as needed
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://cdn.discordapp.com/attachments/1183651745138737262/1183651902743912458/TopCover.png?ex=65891cbc&is=6576a7bc&hm=5bf21289566d85e7e0f1b44607f244b1924de6b914816614cf96ee79504bc5b4&', // Replace with the actual URL
                      ),
                      alignment: Alignment.center,
                      fit: BoxFit.contain, // Set to BoxFit.contain
                    ),
                  ),
                ),
              ),
              if (favoriteBooks.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Buku-buku favorit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (favoriteBooks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 16, right: 16), // Increase top padding
                  child: Card(
                    color: const Color(
                        0xFF010101), // Set the background color of the Card
                    elevation: 8, // Set the elevation as needed
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            favoriteBooks[currentBookIndex][
                                'image'], // Use 'image' for the cover image URL
                            width: 200, // Adjust the width as needed
                            height: 200, // Adjust the height as needed
                          ),
                          const SizedBox(
                              width:
                                  16), // Add space between the book image and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  favoriteBooks[currentBookIndex]
                                      ['name'], // Use 'name' for the book title
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  favoriteBooks[currentBookIndex][
                                      'description'], // Use 'description' for the book description
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  overflow: TextOverflow
                                      .ellipsis, // Use ellipsis for long text
                                  maxLines:
                                      3, // Adjust the number of lines to show
                                ),
                                if (favoriteBooks[currentBookIndex]
                                            ['description']
                                        .length >
                                    100)
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                favoriteBooks[currentBookIndex]
                                                    ['name']),
                                            content: Text(
                                              favoriteBooks[currentBookIndex]
                                                  ['description'],
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      'Read More',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20), // Increase the sp
              if (favoriteBooks.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: prevBook,
                      child: const Text('Prev Book'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: nextBook,
                      child: const Text('Next Book'),
                    )
                  ],
                ) // ace between the card and the button
              ,
              const SizedBox(
                  height:
                      200), // Increase the space between the card and the button
            ],
          ),
        ),
      ),
    );
  }
}
