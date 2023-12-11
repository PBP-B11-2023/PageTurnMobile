import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pageturn_mobile/book.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReturnBookPage extends StatefulWidget {
  const ReturnBookPage({Key? key}) : super(key: key);

  @override
  _ReturnBookPageState createState() => _ReturnBookPageState();
}

class _ReturnBookPageState extends State<ReturnBookPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Book> _booksList = [];
  String _query = "";
  List<String> _selectedGenres = [];
  List<MultiSelectItem<String>> _genresItems = [];

  Future<void> _loadGenres() async {
    var url = Uri.parse('http://10.0.2.2:8000/katalog/get-genres/');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    List<String> genres = List<String>.from(jsonResponse['genres']);
    setState(() {
      _genresItems =
          genres.map((genre) => MultiSelectItem<String>(genre, genre)).toList();
    });
  }

  Future<List<Book>> fetchBooks(CookieRequest request) async {
    print(_query);
    var queryParameters = {
      'search': _query,
      'genres': _selectedGenres,
    };
    var uri =
        Uri.http('10.0.2.2:8000', '/katalog/get-books-genre/', queryParameters);

    final response = await request.get(uri.toString());
    List<Book> listBooks = [];
    for (var d in response) {
      if (d != null) {
        listBooks.add(Book.fromJson(d));
      }
    }
    setState(() {
      _booksList = listBooks;
    });
    return listBooks;
  }

  void _showMultiSelect(BuildContext context) async {
    final items = _genresItems;
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items,
          initialValue: _selectedGenres,
          onConfirm: (values) {
            setState(() {
              _selectedGenres = List<String>.from(values);
              fetchBooks(context.read<CookieRequest>());
            });
          },
        );
      },
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadGenres();
    fetchBooks(context.read<CookieRequest>());
  }

  void _updateSearchResults(String query) {
    setState(() {
      _query = query;
    });
    fetchBooks(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Widget searchBar = _isSearching
        ? TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search books...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _updateSearchResults('');
                  setState(() {
                    _isSearching = false;
                  });
                },
              ),
            ),
            onChanged: (value) {
              _updateSearchResults(value);
            },
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _showMultiSelect(context),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Select Genres',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(color: Colors.grey),
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                ),
              ),
              ElevatedButton(
                  onPressed: _startSearch,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Search ',
                        style: TextStyle(
                            fontSize: 16.0), // Larger font size for button text
                      ),
                      Icon(Icons.search),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors
                        .white, // Match the background color to 'Select Genres' button
                    onPrimary: Colors
                        .black, // Match the text color to 'Select Genres' button
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    side: BorderSide(color: Colors.grey), // Add border
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            14.0), // Horizontal padding inside the button
                  )),
            ],
          );
    return Scaffold(
      drawer: LeftDrawer(),
      appBar: AppBar(
        title: Text(
          'PageTurn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0, // Larger font size for the title
          ),
        ),
        backgroundColor: const Color(0xFFC9C5BA),
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: searchBar,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Books list
          Expanded(
            child: ListView.builder(
              itemCount: _booksList.length,
              itemBuilder: (context, index) {
                Book book = _booksList[index];
                return ListTile(
                  title: Text(book.fields.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle:
                      Text(book.fields.author, style: TextStyle(fontSize: 14)),
                  leading: Image.network(book.fields.image, fit: BoxFit.cover),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: Colors.orange,
          child: Center(
            child: TextButton(
              onPressed: () {
                // Aksi untuk tombol "Mulai Pinjam Buku"
              },
              child: const Text(
                'Mulai Pinjam Buku',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFilterChip(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ChoiceChip(
      label: Text(label),
      onSelected: (bool selected) {
        // Handle chip selection
      },
      selected: false,
    ),
  );
}
