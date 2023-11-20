# PageTurnMobile


- Muhammad Irfan Firmansyah
- Arya Kusuma Daniswara
- Fern Khairunnisha Adelia Aufar
- Irsyad Fadhilah
- Rifdah Nabilah Rahma
- Faiz Abdurrachman

## Deskripsi Aplikaso

Aplikasi mobile PageTurn merupakan perpustakaan digital yang memudahkan pengguna untuk mengakses ratusan e-book dalam satu platform, menghemat waktu dalam mencari dan mengelola buku-buku mereka. Pengguna dapat melihat status peminjaman buku (wishlist, proses peminjaman, atau sudah dikembalikan), memiliki rak buku virtual, dan memberikan ulasan/peringkat untuk buku yang telah dibaca. Selain itu, aplikasi ini juga menampilkan rekomendasi buku yang disesuaikan dengan minat pengguna.
Nama Anggota Kelompok

## Modul Aplikasi

### Daftar Modul
- Modul Authentikasi mengimplementasikan user dapat Register akun baru dan Login dengan akun yang sudah didaftarkan.
- Modul Homepage mengimplementasikan halaman home yang menampilkan semua daftar modul yang ada di dalam aplikasi. : Faiz
- Modul Katalog Buku yang mengimplementasikan informasi dari setiap buku (Nama buku, Penulis, Rating, Genre, Tahun terbit) : Arya
- Modul Request Buku yang mengimplementasikan request buku yang ingin di pinjam namun tidak terdapat di katalog : Fern
- Modul Peminjaman Buku yang mengimplementasikan Buku yang ingin dipinjam atau dikembalikan : Irfan
- Modul Review/ulasan Buku yang mengimplementasikan review dari pembaca buku : Irsyad
- Modul Koleksi Buku Favorit yang mengimplementasikan kumpulan buku-buku yang sering di pinjam : Faiz
- Modul Laporan buku rusak yang mengimplementasikan detail informasi buku yang rusak (nama buku dan alasan rusak) : Rifdah

## Peran Pengguna

1. Pengguna yang Belum Login (Guest):

- Autentikasi:

2. Pengguna dapat melakukan login jika sudah memiliki akun untuk masuk ke aplikasi. Jika belum memiliki akun, pengguna dapat membuat akun baru dengan membuat username dan password sehingga dapat melakukan login untuk masuk ke aplikasi.
Pengguna yang Sudah Login (Member):

- Homepage:
Member dapat melihat homepage yang berisi informasi terkait akun, dan juga button untuk mengakses ke fitur-fitur lainnya.
- Autentikasi:
Member dapat melakukan logout dari aplikasi.
- Katalog Buku:
Member dapat membuka katalog buku untuk melihat informasi dari buku-buku yang tersedia.
- Request Buku:
Member dapat merequest buku yang akan ditambahkan sebagai wishlist jika buku tersebut belum tersedia.
- Peminjaman Buku:
Member dapat melakukan peminjaman buku jika buku tersebut tersedia. Kemudian, member dapat mengembalikan buku tersebut jika sudah selesai dibaca.
- Review Buku:
Member dapat melihat review-review dari suatu buku. Member juga dapat mereview buku yang mereka sudah selesai baca.
- Koleksi Buku Favorit:
Member dapat melihat koleksi buku-buku favorit.
- Laporan buku rusak:
Member dapat membuat laporan buku rusak, jika buku yang mereka pinjam rusak.

3. Admin:
Admin dapat membuka semua yang dapat dibuka oleh member. Tetapi, admin mempunyai satu peran tambahan:
- Katalog Buku:
Admin dapat menambahkan buku baru ke dalam daftar buku.



## Alur Integrasi 
Alur Pengintegrasian dengan Web Service untuk Terhubung dengan Aplikasi Web yang Sudah dibuat saat Proyek Tengah Semester

1. Website yang telah terlebih dahulu dideploy disusun memiliki backend yang dapat menampilkan JSON data-data terkait
2. Membuat file bernama fetch.dart dalam utils folder untuk melakukan proses async mengambil data
3. fetch.dart dilengkapi dengan suatu fungsi yang dapat dipanggil dari luar file kemudian melakukan return data dalam suatu list
4. Fungsi di dalam fetch.dart mengandung url yang digunakan sebagai endpoint JSON
5. Pemanggilan fungsi dilakukan di widget terkait untuk diolah sesuai dengan kebutuhan


## Berita Acara
Link = berita acara: https://docs.google.com/spreadsheets/d/14ZFo0cpXrDy6iEv0GsTosSeeLtI29T_vBQ87AqTEwMA/edit?usp=sharing
