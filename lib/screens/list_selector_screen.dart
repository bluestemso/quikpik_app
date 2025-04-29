import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSelectorScreen extends StatefulWidget {
  const ListSelectorScreen({super.key});

  @override
  State<ListSelectorScreen> createState() => _ListSelectorScreenState();
}

class _ListSelectorScreenState extends State<ListSelectorScreen> {
  final TextEditingController _itemController = TextEditingController();
  final List<String> _items = [];
  String? _selectedItem;
  static const String _itemsKey = 'list_items';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList(_itemsKey) ?? [];
    setState(() {
      _items.addAll(savedItems);
    });
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_itemsKey, _items);
  }

  void _addItem() {
    if (_itemController.text.trim().isEmpty) return;
    if (_items.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 10 items allowed')),
      );
      return;
    }

    setState(() {
      _items.add(_itemController.text.trim());
      _itemController.clear();
    });
    _saveItems();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _saveItems();
  }

  void _selectRandomItem() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add some items first')),
      );
      return;
    }

    setState(() {
      _selectedItem = _items[DateTime.now().millisecondsSinceEpoch % _items.length];
    });

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedItem!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Ensure no focus is given to any widget after dialog dismissal
                  FocusScope.of(context).unfocus();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'List Selector',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Enter an item',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Items (${_items.length}/10)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _items.isEmpty
                      ? const Center(
                          child: Text(
                            'No items added yet',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (context, index) => Card(
                            child: ListTile(
                              title: Text(_items[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeItem(index),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _selectRandomItem,
          child: const Icon(Icons.shuffle),
        ),
      ),
    );
  }
} 