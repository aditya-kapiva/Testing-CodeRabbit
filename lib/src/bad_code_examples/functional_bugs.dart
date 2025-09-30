// Functional Bugs Examples
import 'dart:async';
import 'dart:math';

// Issue: Class with multiple functional bugs
class FunctionalBugs {
  List<String> _items = [];
  int _counter = 0;
  bool _isProcessing = false;
  
  // Issue: Off-by-one error
  String getItemAt(int index) {
    // Issue: Should be index < _items.length
    if (index <= _items.length) {
      return _items[index]; // Will throw IndexError on last valid index
    }
    return '';
  }
  
  // Issue: Infinite loop potential
  void processItems() {
    int i = 0;
    while (i < _items.length) {
      String item = _items[i];
      
      // Issue: Adding items while iterating can cause infinite loop
      if (item.contains('duplicate')) {
        _items.add('processed_$item'); // Issue: Modifying collection during iteration
      }
      
      // Issue: i is not always incremented
      if (!item.startsWith('skip')) {
        i++; // Issue: i not incremented when item starts with 'skip'
      }
    }
  }
  
  // Issue: Race condition bug
  Future<int> incrementCounter() async {
    if (!_isProcessing) {
      _isProcessing = true;
      
      // Issue: Race condition - multiple calls can pass the check
      await Future.delayed(Duration(milliseconds: 100));
      
      _counter++; // Issue: Not atomic, can be corrupted by concurrent access
      
      _isProcessing = false;
      return _counter;
    }
    return _counter;
  }
  
  // Issue: Integer overflow bug
  int calculateScore(int base, int multiplier) {
    // Issue: No overflow check
    return base * multiplier * 1000000; // Can overflow with large inputs
  }
  
  // Issue: Floating point precision bug
  bool areAmountsEqual(double amount1, double amount2) {
    // Issue: Direct floating point comparison
    return amount1 == amount2; // Should use epsilon comparison
  }
  
  // Issue: Logic error in date calculation
  DateTime addBusinessDays(DateTime startDate, int days) {
    DateTime result = startDate;
    int addedDays = 0;
    
    while (addedDays < days) {
      result = result.add(Duration(days: 1));
      
      // Issue: Logic error - Saturday is 6, Sunday is 7, but DateTime.weekday uses 1-7
      if (result.weekday != DateTime.saturday && result.weekday != DateTime.sunday) {
        addedDays++;
      }
      // Issue: This will never add Saturday/Sunday correctly due to wrong logic
    }
    
    return result;
  }
  
  // Issue: Memory leak in event handling
  StreamController<String> _eventController = StreamController<String>();
  List<StreamSubscription> _subscriptions = [];
  
  void addEventHandler(Function(String) handler) {
    // Issue: Subscriptions are never cancelled - memory leak
    var subscription = _eventController.stream.listen(handler);
    _subscriptions.add(subscription);
    // Issue: No cleanup mechanism
  }
  
  // Issue: Incorrect error handling
  Future<String> fetchData(String url) async {
    try {
      // Simulated network call
      await Future.delayed(Duration(seconds: 1));
      
      if (url.isEmpty) {
        throw Exception('Empty URL');
      }
      
      // Issue: Wrong exception type caught
      return 'Data from $url';
    } on FormatException catch (e) {
      // Issue: Catching wrong exception type for network errors
      return 'Error: ${e.toString()}';
    }
    // Issue: Other exceptions not handled
  }
  
  // Issue: Boundary condition bug
  List<String> splitString(String input, int maxLength) {
    List<String> result = [];
    
    // Issue: Doesn't handle empty string or null input
    for (int i = 0; i < input.length; i += maxLength) {
      // Issue: Doesn't handle case where remaining string is shorter than maxLength
      String chunk = input.substring(i, i + maxLength); // Will throw on last chunk
      result.add(chunk);
    }
    
    return result;
  }
  
  // Issue: State corruption bug
  Map<String, int> _userScores = {};
  
  void updateUserScore(String userId, int points) {
    // Issue: Concurrent modification can corrupt state
    int currentScore = _userScores[userId] ?? 0;
    
    // Simulate processing time
    Future.delayed(Duration(milliseconds: 50), () {
      // Issue: Score can be overwritten by concurrent calls
      _userScores[userId] = currentScore + points;
    });
  }
  
  // Issue: Resource leak bug
  List<Timer> _timers = [];
  
  void startPeriodicTask(Duration interval) {
    Timer timer = Timer.periodic(interval, (timer) {
      // Do periodic work
      print('Periodic task executed');
    });
    
    _timers.add(timer);
    // Issue: Timers are never cancelled, causing resource leak
  }
  
  // Issue: Incorrect algorithm implementation
  int findMaxValue(List<int> numbers) {
    if (numbers.isEmpty) return 0;
    
    int max = numbers[0];
    
    // Issue: Starting from index 0 instead of 1
    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i] > max) {
        max = numbers[i];
      }
    }
    
    return max; // Works but inefficient due to extra comparison
  }
  
  // Issue: Deadlock potential
  bool _lock1 = false;
  bool _lock2 = false;
  
  Future<void> methodA() async {
    while (_lock1) await Future.delayed(Duration(milliseconds: 10));
    _lock1 = true;
    
    await Future.delayed(Duration(milliseconds: 100));
    
    // Issue: Potential deadlock if methodB is called concurrently
    while (_lock2) await Future.delayed(Duration(milliseconds: 10));
    _lock2 = true;
    
    // Do work
    
    _lock2 = false;
    _lock1 = false;
  }
  
  Future<void> methodB() async {
    while (_lock2) await Future.delayed(Duration(milliseconds: 10));
    _lock2 = true;
    
    await Future.delayed(Duration(milliseconds: 100));
    
    // Issue: Acquiring locks in different order - potential deadlock
    while (_lock1) await Future.delayed(Duration(milliseconds: 10));
    _lock1 = true;
    
    // Do work
    
    _lock1 = false;
    _lock2 = false;
  }
  
  // Issue: Incorrect sorting implementation
  void bubbleSortWithBug(List<int> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list.length - 1; j++) { // Issue: Should be list.length - i - 1
        if (list[j] > list[j + 1]) {
          // Swap
          int temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
      // Issue: Doing unnecessary comparisons in each iteration
    }
  }
  
  // Issue: Cache invalidation bug
  Map<String, String> _cache = {};
  DateTime _lastCacheUpdate = DateTime.now();
  
  String getCachedValue(String key) {
    // Issue: Cache never expires
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }
    
    // Simulate expensive operation
    String value = 'computed_$key';
    _cache[key] = value;
    
    return value;
  }
  
  void invalidateCache() {
    // Issue: Only clears cache but doesn't update timestamp
    _cache.clear();
    // Issue: _lastCacheUpdate not updated
  }
  
  // Issue: Incorrect mathematical calculation
  double calculateCompoundInterest(double principal, double rate, int years) {
    // Issue: Formula is incorrect
    // Should be: principal * pow((1 + rate), years)
    return principal + (rate * years); // Issue: Simple interest instead of compound
  }
  
  // Issue: String manipulation bug
  String reverseWords(String sentence) {
    List<String> words = sentence.split(' ');
    List<String> reversed = [];
    
    // Issue: Logic error - reversing individual words instead of word order
    for (String word in words) {
      reversed.add(word.split('').reversed.join(''));
    }
    
    return reversed.join(' ');
    // Issue: Should reverse order of words, not characters in each word
  }
  
  // Issue: File handling bug
  Future<void> saveDataToFile(String filename, String data) async {
    try {
      // Issue: No check if file already exists or if directory exists
      // Issue: No atomic write operation
      var file = File(filename);
      await file.writeAsString(data);
      
      // Issue: No verification that write was successful
    } catch (e) {
      // Issue: Silently ignoring write errors
      print('Write failed: $e');
    }
  }
  
  // Issue: Cleanup not called
  void dispose() {
    // Issue: Incomplete cleanup
    _eventController.close();
    // Issue: _subscriptions not cancelled
    // Issue: _timers not cancelled
    _items.clear();
  }
}
