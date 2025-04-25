import 'dart:math';
import 'package:flutter/material.dart';

class CoinFlipScreen extends StatefulWidget {
  const CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFlipping = false;
  bool _isHeads = true;
  final Random _random = Random();
  static const int _numberOfFlips = 10; // Number of times the coin will flip
  static const Duration _flipDuration = Duration(milliseconds: 2000); // Total duration of all flips

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _flipDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCoin() {
    if (_isFlipping) return;

    setState(() {
      _isFlipping = true;
      _isHeads = _random.nextBool();
    });

    _controller.forward(from: 0).then((_) {
      setState(() {
        _isFlipping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Text(
                'Tap the coin to flip it!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: GestureDetector(
                        onTap: _flipCoin,
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            // Calculate the rotation angle for multiple flips
                            final rotation = _controller.value * _numberOfFlips * pi;
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(rotation),
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isHeads ? Colors.blueGrey : Colors.blueGrey.shade700,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 16),
                                      blurRadius: 3,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: _isFlipping
                                    ? null // Hide icon during flip
                                    : Icon(
                                        _isHeads ? Icons.home : Icons.person,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AnimatedOpacity(
                      opacity: _isFlipping ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _isHeads ? 'Tails' : 'Heads',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 