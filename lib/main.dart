import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import AdMob

void main() async {
  // Wajib ditambahkan untuk inisialisasi AdMob sebelum aplikasi berjalan
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';

  // Variabel untuk Iklan Banner
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  // Banner Ad Unit ID milikmu
  final String adUnitId = 'ca-app-pub-4308881852546172/3963104428';

  @override
  void initState() {
    super.initState();
    _loadAd(); // Muat iklan saat aplikasi dibuka
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true; // Tampilkan iklan jika berhasil dimuat
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Gagal memuat iklan: ${err.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Hapus iklan dari memori saat aplikasi ditutup
    super.dispose();
  }

  void _tapped(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    List<List<int>> winLines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var line in winLines) {
      if (board[line[0]] != '' &&
          board[line[0]] == board[line[1]] &&
          board[line[1]] == board[line[2]]) {
        setState(() {
          winner = board[line[0]];
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        winner = 'Draw';
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
    });
  }

  Widget _getPlayerIcon(String player) {
    if (player == 'X') {
      return Icon(Icons.close_rounded, color: Colors.red[700], size: 70);
    } else if (player == 'O') {
      return Icon(Icons.panorama_fish_eye_rounded,
          color: Colors.blue[700], size: 60);
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe Pro',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                winner == ''
                    ? 'Giliran: ${isXTurn ? "X" : "O"}'
                    : winner == 'Draw'
                        ? 'Permainan Seri!'
                        : 'Pemenang: $winner 🎉',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _tapped(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              colorScheme.secondaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: _getPlayerIcon(board[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FilledButton.icon(
                onPressed: _resetGame,
                icon: Icon(Icons.replay_rounded),
                label: Text('Main Ulang', style: TextStyle(fontSize: 18)),
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            SizedBox(height: 10), // Sedikit jarak antara tombol dan iklan
          ],
        ),
      ),
      // Di sinilah iklan Banner akan muncul di bagian paling bawah layar
      // Di sinilah iklan Banner akan muncul di bagian paling bawah layar
      bottomNavigationBar: _isAdLoaded
          ? Container(
              color: Colors.transparent,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : Container(
              height: 50,
              color: Colors.grey[300], // Warna background abu-abu muda
              child: Center(
                child: Text(
                  'Ruang Iklan (Menunggu Google)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ),
      // Ruang kosong jika iklan belum termuat
    );
  }
}
