import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RandomColorScreen extends StatefulWidget {
  const RandomColorScreen({super.key});

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  final List<Color> _availableColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];
  
  late List<bool> _selectedColors;
  Color _currentColor = Colors.red;
  late SharedPreferences _prefs;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadColorConfiguration();
  }

  Future<void> _loadColorConfiguration() async {
    setState(() => _isLoading = true);
    try {
      _prefs = await SharedPreferences.getInstance();
      final savedColors = _prefs.getStringList('selectedColors');
      if (savedColors != null) {
        setState(() {
          _selectedColors = savedColors.map((e) => e == 'true').toList();
        });
      } else {
        setState(() {
          _selectedColors = List.filled(6, true);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load color configuration'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveColorConfiguration() async {
    try {
      await _prefs.setStringList(
        'selectedColors',
        _selectedColors.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save color configuration'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleColor(int index) {
    setState(() {
      _selectedColors[index] = !_selectedColors[index];
    });
    _saveColorConfiguration();
  }

  String _getColorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.green) return 'Green';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.purple) return 'Purple';
    return 'Unknown';
  }

  void _generateRandomColor() {
    final availableColors = <Color>[];
    for (var i = 0; i < _availableColors.length; i++) {
      if (_selectedColors[i]) {
        availableColors.add(_availableColors[i]);
      }
    }

    if (availableColors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one color'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _currentColor = availableColors[Random().nextInt(availableColors.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: _currentColor,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: [
                Container(
                  height: 120,
                  margin: EdgeInsets.zero,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableColors.length,
                    itemBuilder: (context, index) {
                      final color = _availableColors[index];
                      final isSelected = _selectedColors[index];
                      return GestureDetector(
                        onTap: () => _toggleColor(index),
                        child: Container(
                          width: MediaQuery.of(context).size.width / _availableColors.length,
                          decoration: BoxDecoration(
                            color: color,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (!isSelected)
                                const Icon(
                                  Icons.block,
                                  color: Colors.white,
                                  size: 32,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _generateRandomColor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _currentColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Pick a New Color'),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getColorName(_currentColor),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
} 