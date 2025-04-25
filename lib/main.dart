import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:randomness_90_minute_flutter/screens/coin_flip_screen.dart';
import 'package:randomness_90_minute_flutter/screens/random_number_screen.dart';
import 'package:randomness_90_minute_flutter/screens/random_color_screen.dart';
import 'package:randomness_90_minute_flutter/screens/list_selector_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Randomness Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.deepPurple.withValues(alpha: 255),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    CoinFlipScreen(),
    RandomNumberScreen(),
    RandomColorScreen(),
    ListSelectorScreen(),
  ];

  static const List<String> _titles = [
    'Coin Flip',
    'Random Number',
    'Random Color',
    'List Selector',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            label: 'Coin Flip',
          ),
          NavigationDestination(
            icon: Icon(Icons.numbers),
            label: 'Random Number',
          ),
          NavigationDestination(
            icon: Icon(Icons.color_lens),
            label: 'Random Color',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'List Selector',
          ),
        ],
      ),
    );
  }
}
