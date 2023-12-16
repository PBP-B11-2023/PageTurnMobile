import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pageturn_mobile/book.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({Key? key}) : super(key: key);

  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Book> _booksList = [];
  List<int> _selectedBooks = [];
  String _query = "";
  List<String> _selectedGenres = [];
  List<MultiSelectItem<String>> _genresItems = [];

  Future<void> _loadGenres() async {
    var url = Uri.parse('http://localhost:8000/katalog/get-genres/');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    List<String> genres = List<String>.from(jsonResponse['genres']);
    setState(() {
      _genresItems =
          genres.map((genre) => MultiSelectItem<String>(genre, genre)).toList();
    });
  }

  Future<List<Book>> fetchBooks(CookieRequest request) async {
    var queryParameters = {
      'search': _query,
      'genres': _selectedGenres,
    };
    var uri = Uri.http(
        'localhost:8000', '/katalog/get-books-genre/', queryParameters);

    final response = await request.get(uri.toString());
    List<Book> listBooks = [];
    for (var d in response) {
      if (d != null) {
        listBooks.add(Book.fromJson(d));
      }
    }
    listBooks.sort((a, b) => a.fields.name.compareTo(b.fields.name));
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
            style: TextStyle(
              color: Colors.white,
            ),
            cursorColor: Colors.white,
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search books...',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white),
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
          'Peminjaman',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0, // Larger font size for the title
          ),
        ),
        backgroundColor: const Color(0xFF282626),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 10.0),
            child: searchBar,
          ),
        ),
      ),
      body: Column(
        children: [
          // Books list
          Expanded(
            child: ListView.builder(
              itemCount: _booksList.length,
              itemBuilder: (context, index) {
                Book book = _booksList[index];
                bool isSelected = _selectedBooks.contains(book.pk);

                return InkWell(
                  onTap: () {
                    if (!book.fields.isDipinjam){
                      setState(() {
                        if (isSelected) {
                          _selectedBooks.remove(book.pk);
                        } else {
                          _selectedBooks.add(book.pk);
                        }
                      });
                    }
                  },
                  child: Container(
                    color: book.fields.isDipinjam ? Colors.red : isSelected ? Colors.blueGrey : Colors.white,
                    child: ListTile(
                      title: Text(book.fields.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text(book.fields.author, style: TextStyle(fontSize: 14)),
                      leading: Image.network(
                        book.fields.image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 200,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Your existing BottomAppBar
          BottomAppBar(
            child: Container(
              height: 50,
              color: Color(0xffc06c34),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    final response = await request.post(
                        "http://localhost:8000/peminjaman/get-selected/",
                        {
                          'booklist': jsonEncode(_selectedBooks),
                        }
                    );
                    _selectedBooks.clear();
                  },
                  child: const Text(
                    'Pinjam Buku',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // BottomNavigationBar
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Peminjaman',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'Pengembalian',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History Peminjaman',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              switch (index) {
                case 0:
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PeminjamanPage()));
                  break;
                case 1:
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PeminjamanPage()));
                  break;
                case 2:
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PeminjamanPage()));
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
