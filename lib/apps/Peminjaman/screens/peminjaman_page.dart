import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pageturn_mobile/apps/Homepage/menu.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/history_page.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/pengembalian_page.dart';
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
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Book> _booksList = [];
  List<int> _selectedBooks = [];
  String _query = "";
  List<String> _selectedGenres = [];
  List<MultiSelectItem<String>> _genresItems = [];

  Future<void> _loadGenres() async {
    var url = Uri.parse('http://127.0.0.1:8000/katalog/get-genres/');
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
        '127.0.0.1:8000', '/katalog/get-books-genre/', queryParameters);

    final response = await request.get(uri.toString());
    List<Book> listBooks = [];
    for (var d in response) {
      if (d != null) {
        listBooks.add(Book.fromJson(d));
      }
    }
    listBooks.sort((a, b) {
      if (a.fields.isDipinjam == b.fields.isDipinjam) {
        return a.fields.name.compareTo(b.fields
            .name); // Alphabetical sorting if `isDipinjam` status is same
      }
      return a.fields.isDipinjam
          ? 1
          : -1; // Books with `isDipinjam` as false come first
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Instruksi'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Klik buku yang ingin dipinjam,'),
                    Text('Merah artinya tidak tersedia.'),
                  ],
                ),
              ),
              actions: <Widget>[
                // Cancel button
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
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
          'Peminjaman Buku',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0, // Larger  font size for the title
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
                    if (!book.fields.isDipinjam) {
                      setState(() {
                        if (isSelected) {
                          _selectedBooks.remove(book.pk);
                        } else {
                          if (_selectedBooks.length >= 10) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("Hanya bisa meminjam maksimal 10 buku!"),
                            ));
                          } else {
                            _selectedBooks.add(book.pk);
                          }
                        }
                      });
                    }
                  },
                  child: Container(
                    color: book.fields.isDipinjam
                        ? Color(0xFFF08080)
                        : isSelected
                            ? Color(0xFF87CEFA)
                            : Colors.white,
                    child: ListTile(
                      title: Text(book.fields.name,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text(book.fields.author,
                          style: TextStyle(fontSize: 14)),
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
          SizedBox(height: 55),
          if (_selectedBooks.isNotEmpty) SizedBox(height: 90),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Your existing BottomAppBar
          if (_selectedBooks.isNotEmpty)
            BottomAppBar(
              child: InkWell(
                onTap: () async {
                  // Retrieve the list of selected books
                  List<String> selectedBookNames = _selectedBooks.map((bookId) {
                    return _booksList
                        .firstWhere((book) => book.pk == bookId)
                        .fields
                        .name;
                  }).toList();
                  if (_selectedBooks.isEmpty) {
                    // Show a simple alert dialog if no books are selected
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Belum Memilih Buku'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'Pilihlah minimal satu buku untuk dipinjam!'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String loanDays = '';
                        return AlertDialog(
                          title: const Text('Konfirmasi Peminjaman'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Buku yang dipinjam:'),
                                ...selectedBookNames
                                    .map((name) => Text('- $name')),
                                TextField(
                                  onChanged: (value) {
                                    loanDays = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'Ketik durasi peminjaman (1-14 hari)',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            // Cancel button
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // This will close the dialog
                              },
                            ),
                            // OK button
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                // Implement your logic to process the loan here
                                final response = await request.post(
                                    "http://127.0.0.1:8000/peminjaman/get-selected/",
                                    {
                                      'durasi': loanDays,
                                      'booklist': jsonEncode(_selectedBooks),
                                    });
                                // Then close the dialog
                                Navigator.of(context).pop();
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Status'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('${response['message']}'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          // Cancel button
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              bool status = response['status'];
                                              print(status);
                                              if (status) {
                                                _selectedBooks.clear();
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PengembalianPage()));
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  height: 50,
                  color: Color(0xffc06c34),
                  child: Center(
                    child: const Text(
                      'Pinjam Buku',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PengembalianPage()));
                  break;
                case 2:
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HistoryPage()));
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}