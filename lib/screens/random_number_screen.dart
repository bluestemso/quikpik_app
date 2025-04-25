import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RandomNumberScreen extends StatefulWidget {
  const RandomNumberScreen({super.key});

  @override
  State<RandomNumberScreen> createState() => _RandomNumberScreenState();
}

class _RandomNumberScreenState extends State<RandomNumberScreen> {
  final TextEditingController _lowerBoundController = TextEditingController();
  final TextEditingController _upperBoundController = TextEditingController();
  int? _randomNumber;
  String? _errorMessage;

  @override
  void dispose() {
    _lowerBoundController.dispose();
    _upperBoundController.dispose();
    super.dispose();
  }

  void _generateRandomNumber() {
    final lowerBound = int.tryParse(_lowerBoundController.text);
    final upperBound = int.tryParse(_upperBoundController.text);

    if (lowerBound == null || upperBound == null) {
      setState(() {
        _errorMessage = 'Please enter valid numbers';
        _randomNumber = null;
      });
      return;
    }

    if (lowerBound >= upperBound) {
      setState(() {
        _errorMessage = 'Lower bound must be less than upper bound';
        _randomNumber = null;
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _randomNumber = lowerBound + Random().nextInt(upperBound - lowerBound + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Random Number Generator',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _lowerBoundController,
                decoration: const InputDecoration(
                  labelText: 'Lower Bound',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _upperBoundController,
                decoration: const InputDecoration(
                  labelText: 'Upper Bound',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _generateRandomNumber,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Generate Random Number',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),
              if (_randomNumber != null)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your random number is:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _randomNumber.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 