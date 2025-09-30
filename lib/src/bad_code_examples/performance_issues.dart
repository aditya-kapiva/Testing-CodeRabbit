// Performance Issues Examples
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

// Issue: Widget that blocks main thread
class BlockingMainThreadWidget extends StatefulWidget {
  @override
  _BlockingMainThreadWidgetState createState() =>
      _BlockingMainThreadWidgetState();
}

class _BlockingMainThreadWidgetState extends State<BlockingMainThreadWidget> {
  List<String> data = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Performance Issues")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _performBlockingOperation,
            child: Text("Block Main Thread"),
          ),
          ElevatedButton(
            onPressed: _performInefficiientOperation,
            child: Text("Inefficient Operation"),
          ),
          if (isLoading) CircularProgressIndicator(),
          Expanded(
            child: ListView.builder(
              // Issue: No virtualization, renders all items
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _buildExpensiveListItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Issue: Blocking main thread with synchronous operations
  void _performBlockingOperation() {
    setState(() {
      isLoading = true;
    });

    // Issue: Synchronous file operations on main thread
    Directory tempDir = Directory('/tmp/heavy_processing');
    if (!tempDir.existsSync()) {
      tempDir.createSync(recursive: true); // Blocking
    }

    // Issue: Heavy computation on main thread
    List<int> numbers = List.generate(1000000, (index) => index);

    // Issue: Inefficient sorting algorithm O(n²)
    for (int i = 0; i < numbers.length; i++) {
      for (int j = i + 1; j < numbers.length; j++) {
        if (numbers[i] > numbers[j]) {
          int temp = numbers[i];
          numbers[i] = numbers[j];
          numbers[j] = temp;
        }
      }
    }

    // Issue: Synchronous file I/O
    for (int i = 0; i < 100; i++) {
      File file = File('/tmp/heavy_processing/file_$i.txt');
      file.writeAsStringSync('Data for file $i\n' * 1000); // Blocking write
    }

    setState(() {
      data = numbers.map((n) => n.toString()).toList();
      isLoading = false;
    });
  }

  // Issue: Inefficient operations
  void _performInefficiientOperation() {
    setState(() {
      isLoading = true;
    });

    // Issue: Inefficient string concatenation
    String result = "";
    for (int i = 0; i < 10000; i++) {
      result += "Item $i "; // Creates new string each time
    }

    // Issue: Inefficient list operations
    List<String> items = [];
    for (int i = 0; i < 5000; i++) {
      items.insert(0, "Item $i"); // O(n) operation in loop = O(n²)
    }

    // Issue: Inefficient map operations
    Map<String, int> counts = {};
    for (String item in items) {
      if (counts.containsKey(item)) {
        counts[item] = counts[item]! + 1;
      } else {
        counts[item] = 1;
      }
    }

    // Issue: Converting to JSON and back unnecessarily
    String jsonString = json.encode(counts);
    Map<String, dynamic> decoded = json.decode(jsonString);

    setState(() {
      data = decoded.keys.toList();
      isLoading = false;
    });
  }

  // Issue: Expensive widget building
  Widget _buildExpensiveListItem(int index) {
    // Issue: Heavy computation in build method
    String expensiveText = _performExpensiveTextProcessing(index);

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Issue: Creating complex widgets for each item
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO((index * 123) % 255, (index * 456) % 255,
                      (index * 789) % 255, 1.0),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                expensiveText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Issue: More expensive operations
          ...List.generate(
              10,
              (i) => Container(
                    height: 20,
                    color: Colors.primaries[i % Colors.primaries.length],
                  )),
        ],
      ),
    );
  }

  // Issue: Expensive text processing in UI thread
  String _performExpensiveTextProcessing(int index) {
    String text = "Item $index";

    // Issue: Unnecessary complex text processing
    for (int i = 0; i < 100; i++) {
      text = text.replaceAllMapped(RegExp(r'\d'), (match) {
        return (int.parse(match.group(0)!) * 2).toString();
      });
      text = text.toUpperCase().toLowerCase();
    }

    return text;
  }
}

// Issue: Class with performance problems
class InefficiientDataProcessor {
  // Issue: Inefficient data structures
  List<Map<String, dynamic>> data = [];

  // Issue: O(n²) search algorithm
  Map<String, dynamic>? findItem(String id) {
    for (int i = 0; i < data.length; i++) {
      for (String key in data[i].keys) {
        if (key == 'id' && data[i][key] == id) {
          return data[i];
        }
      }
    }
    return null;
  }

  // Issue: Inefficient sorting
  void sortDataByName() {
    // Issue: Bubble sort O(n²)
    for (int i = 0; i < data.length - 1; i++) {
      for (int j = 0; j < data.length - i - 1; j++) {
        String name1 = data[j]['name'] ?? '';
        String name2 = data[j + 1]['name'] ?? '';
        if (name1.compareTo(name2) > 0) {
          var temp = data[j];
          data[j] = data[j + 1];
          data[j + 1] = temp;
        }
      }
    }
  }

  // Issue: Memory inefficient filtering
  List<Map<String, dynamic>> filterData(
      bool Function(Map<String, dynamic>) predicate) {
    List<Map<String, dynamic>> result = [];

    // Issue: Creating deep copies unnecessarily
    for (var item in data) {
      Map<String, dynamic> copy = {};
      for (String key in item.keys) {
        copy[key] = item[key];
      }

      if (predicate(copy)) {
        result.add(copy);
      }
    }

    return result;
  }

  // Issue: Inefficient batch operations
  void batchUpdate(List<String> ids, Map<String, dynamic> updates) {
    for (String id in ids) {
      // Issue: O(n) search for each update
      var item = findItem(id);
      if (item != null) {
        for (String key in updates.keys) {
          item[key] = updates[key];
        }
      }
    }
  }

  // Issue: Poor caching strategy
  Map<String, String> _cache = {};

  String processExpensiveOperation(String input) {
    // Issue: Cache never cleared, grows indefinitely
    if (_cache.containsKey(input)) {
      return _cache[input]!;
    }

    // Issue: Expensive operation
    String result = input;
    for (int i = 0; i < 1000; i++) {
      result = result + result.hashCode.toString();
      result = result.substring(0, result.length ~/ 2);
    }

    _cache[input] = result;
    return result;
  }
}

// Issue: Widget with no optimization
class UnoptimizedListWidget extends StatelessWidget {
  final List<String> items;

  UnoptimizedListWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      // Issue: No virtualization - renders all items at once
      children: items.map((item) {
        // Issue: Expensive widget creation for each item
        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Issue: Creating complex widgets for simple display
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                ),
                child: Center(
                  child: Text(
                    item.substring(0, 1),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Description for $item",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(), // Issue: Converting to list - no lazy evaluation
    );
  }
}
