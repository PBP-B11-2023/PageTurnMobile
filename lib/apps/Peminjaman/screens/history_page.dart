// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pageturn_mobile/apps/Katalog/models/book.dart';
import 'package:pageturn_mobile/apps/Peminjaman/models/peminjaman.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/peminjaman_page.dart';
import 'package:pageturn_mobile/apps/Peminjaman/screens/pengembalian_page.dart';
import 'package:pageturn_mobile/components/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Peminjaman> _dipinjam = [];
  final List<int> _telat = [];
  int _selectedIndex = 2;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Book> _booksList = [];
  List<Book> _allBooks = [];
  List<Peminjaman> _peminjamanList = [];
  final List<int> _selectedBooks = [];
  String _query = "";
  List<String> _selectedGenres = [];
  List<MultiSelectItem<String>> _genresItems = [];

  Future<void> _loadGenres() async {
    var url = Uri.parse(
        'https://pageturn-b11-tk.pbp.cs.ui.ac.id/katalog/get-genres/');
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    List<String> genres = List<String>.from(jsonResponse['genres']);
    setState(() {
      _genresItems =
          genres.map((genre) => MultiSelectItem<String>(genre, genre)).toList();
    });
  }

  Future<List<Book>> fetchBooks(CookieRequest request) async {
    final response1 = await request
        .get('https://pageturn-b11-tk.pbp.cs.ui.ac.id/katalog/get-book/');
    List<Book> allBooks = [];
    for (var d in response1) {
      if (d != null) {
        allBooks.add(Book.fromJson(d));
      }
    }
    _allBooks = allBooks;
    return allBooks;
  }

  Future<List<Book>> fetchPeminjaman(CookieRequest request) async {
    var queryParameters = {
      'search': _query,
      'genres': _selectedGenres,
    };
    var uri = Uri.https('pageturn-b11-tk.pbp.cs.ui.ac.id',
        '/peminjaman/get-history/', queryParameters);

    final response = await request.get(uri.toString());
    List<Book> listBooks = [];
    List<Peminjaman> listPeminjaman = [];
    for (var d in response) {
      if (d != null) {
        Peminjaman item = Peminjaman.fromJson(d);
        Book? book =
            _allBooks.firstWhere((book) => book.pk == item.fields.book);
        if (!listBooks.contains(book)) {
          listBooks.add(book);
        }
        listPeminjaman.add(item);
      }
    }
    listBooks.sort((a, b) {
      return a.fields.name.compareTo(b.fields.name);
    });
    setState(() {
      _booksList = listBooks;
      _peminjamanList = listPeminjaman;
    });
    return listBooks;
  }

  void _showMultiSelect(BuildContext context) async {
    final items = _genresItems;
    await showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                Colors.white, // Ensuring dialog background is white
            colorScheme: const ColorScheme.dark(
              // Pastikan skema warna gelap
              primary: Colors.white, // Warna utama dalam dialog
              onPrimary:
                  Colors.white, // Warna untuk teks dan ikon pada primaryColor
              surface: Colors.black87, // Warna permukaan komponen
              onSurface: Colors.white, // Warna teks dan ikon pada surface
              // secondary: Colors.white, // Warna aksen atau sekunder
            ),
          ),
          child: MultiSelectDialog(
            backgroundColor:
                Colors.white, // Set your desired background color here
            items: items,
            initialValue: _selectedGenres,
            onConfirm: (values) {
              setState(() {
                _selectedGenres = List<String>.from(values);
                fetchPeminjaman(context.read<CookieRequest>());
              });
            },
          ),
        );
      },
    );
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xff282626),
              surfaceTintColor: Colors.transparent,
              title: const Text(
                'Instruksi',
                style: TextStyle(color: Colors.white),
              ),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Klik buku untuk melihat detail peminjaman.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  Future<void> _initializeData() async {
    CookieRequest request = context.read<CookieRequest>();
    await fetchBooks(request);
    _loadGenres();
    fetchPeminjaman(request);
  }

  void _updateSearchResults(String query) {
    setState(() {
      _query = query;
    });
    fetchPeminjaman(context.read<CookieRequest>());
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = _isSearching
        ? TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            cursorColor: Colors.white,
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search books...',
              hintStyle: const TextStyle(color: Colors.white),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.white),
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
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                ),
                child: const Row(
                  children: <Widget>[
                    Text(
                      'Select Genres',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _startSearch,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors
                        .white, // Match the text color to 'Select Genres' button
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    side: const BorderSide(color: Colors.grey), // Add border
                    padding: const EdgeInsets.symmetric(
                        horizontal:
                            14.0), // Horizontal padding inside the button
                  ),
                  child: const Row(
                    children: <Widget>[
                      Text(
                        'Search ',
                        style: TextStyle(
                            fontSize: 16.0), // Larger font size for button text
                      ),
                      Icon(Icons.search),
                    ],
                  )),
            ],
          );
    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text(
          'History Peminjaman Buku',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0, // Larger  font size for the title
          ),
        ),
        backgroundColor: const Color(0xFF282626),
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10.0),
            child: searchBar,
          ),
        ),
      ),
      body: Column(
        children: [
          // Books list
          Expanded(
            child: _booksList.isEmpty
                ? const Center(
                    child: Text(
                      "Kosong.",
                      textAlign: TextAlign.center, // Align text to center
                      style: TextStyle(
                        fontSize: 28, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Bold text
                        color: Colors.grey, // Optional: for grey text color
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _booksList.length,
                    itemBuilder: (context, index) {
                      Book book = _booksList[index];
                      bool isSelected = _selectedBooks.contains(book.pk);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBooks.clear();
                            _selectedBooks.add(book.pk);
                            _dipinjam = _peminjamanList
                                .where((item) => item.fields.book == book.pk)
                                .toList();
                            _telat.clear();
                            for (int i = 0; i < _dipinjam.length; i++) {
                              DateTime date = DateTime.parse(
                                  _dipinjam[i].fields.tglDikembalikan);
                              Duration diff =
                                  date.difference(_dipinjam[i].fields.tglBatas);
                              _telat.add(diff.inDays);
                            }
                          });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: const Color(0xff282626),
                                surfaceTintColor: Colors.transparent,
                                title: Text(
                                  book.fields.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Adjust the font size
                                    fontWeight:
                                        FontWeight.bold, // Make the title bold
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      for (int i = 0; i < _dipinjam.length; i++)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Dipinjam pada: ${DateFormat('yyyy-MM-dd').format(_dipinjam[i].fields.tglDipinjam)}.',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'Dikembalikan pada: ${_dipinjam[i].fields.tglDikembalikan}.',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            (_telat[i] <= 0)
                                                ? const Text(
                                                    'Tidak telat.',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    'Telat ${_telat[i]} hari.',
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                            const Text(''),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          color: isSelected
                              ? const Color(0xFF87CEFA)
                              : Colors.white,
                          child: ListTile(
                            title: Text(
                              book.fields.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              book.fields.author,
                              style: const TextStyle(fontSize: 14),
                            ),
                            leading: Image.network(
                              book.fields.image,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 200,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                // Handle rendering errors
                                return Image.network(
                                  'https://cdn.discordapp.com/attachments/1049115719306051644/1186325973268975716/nope-not-here.png?ex=6592d728&is=65806228&hm=ed928cadb7e25d1ac275f43953b9498ca39557ddfffaa82b07443810b4c3caac&',
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 200,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 55),
        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomNavigationBar(
            backgroundColor: const Color(0xff282428),
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
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PeminjamanPage()));
                  break;
                case 1:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PengembalianPage()));
                  break;
                case 2:
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HistoryPage()));
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}
