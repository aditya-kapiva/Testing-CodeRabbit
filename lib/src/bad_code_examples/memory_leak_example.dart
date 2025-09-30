// Memory Leak Examples
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// Issue: Widget with multiple memory leaks
class MemoryLeakWidget extends StatefulWidget {
  @override
  _MemoryLeakWidgetState createState() => _MemoryLeakWidgetState();
}

class _MemoryLeakWidgetState extends State<MemoryLeakWidget>
    with TickerProviderStateMixin {
  // Issue: Controllers not disposed
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this, // Issue: Still not disposed properly
  );

  // Issue: Streams not closed
  StreamController<String> _streamController = StreamController<String>();
  StreamSubscription? _subscription;

  // Issue: Timer not cancelled
  Timer? _timer;

  // Issue: Large data structures kept in memory
  List<Uint8List> _imageDataList = [];
  Map<String, List<String>> _cachedData = {};

  @override
  void initState() {
    super.initState();

    // Issue: Creating timer that's never cancelled
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Issue: Continuously adding data without cleanup
        _imageDataList.add(Uint8List(1024 * 1024)); // 1MB each time
      });
    });

    // Issue: Stream subscription not properly managed
    _subscription = _streamController.stream.listen((data) {
      setState(() {
        if (!_cachedData.containsKey(data)) {
          _cachedData[data] = [];
        }
        _cachedData[data]!.add(DateTime.now().toString());
      });
    });

    // Issue: Adding listener without removing
    _scrollController.addListener(() {
      print("Scroll position: ${_scrollController.offset}");
    });
  }

  // Issue: Method that creates memory leaks
  void _loadLargeData() {
    for (int i = 0; i < 1000; i++) {
      // Issue: Creating large objects without cleanup
      List<String> largeList = List.generate(10000, (index) => "Item $index");
      _cachedData["batch_$i"] = largeList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Memory Leak Example")),
      body: Column(
        children: [
          TextField(controller: _controller1),
          TextField(controller: _controller2),
          ElevatedButton(
            onPressed: _loadLargeData,
            child: Text("Load Large Data"),
          ),
          Text("Cached items: ${_cachedData.length}"),
          Text("Image data count: ${_imageDataList.length}"),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Issue: Incomplete disposal - major memory leaks
    // _controller1.dispose(); // Commented out - memory leak
    // _controller2.dispose(); // Commented out - memory leak
    // _scrollController.dispose(); // Commented out - memory leak
    // _animationController.dispose(); // Commented out - memory leak
    // _streamController.close(); // Commented out - memory leak
    // _subscription?.cancel(); // Commented out - memory leak
    // _timer?.cancel(); // Commented out - memory leak

    // Issue: Not clearing large data structures
    // _imageDataList.clear();
    // _cachedData.clear();

    super.dispose();
  }
}

// Issue: Singleton with memory leaks
class LeakyDataManager {
  static LeakyDataManager? _instance;

  // Issue: Static data that's never cleared
  static Map<String, List<dynamic>> _staticCache = {};
  static List<StreamController> _controllers = [];
  static List<Timer> _timers = [];

  List<Uint8List> _largeDataBuffers = [];
  Map<String, dynamic> _userData = {};

  LeakyDataManager._();

  static LeakyDataManager get instance {
    _instance ??= LeakyDataManager._();
    return _instance!;
  }

  void addData(String key, dynamic data) {
    // Issue: Continuously growing cache without limits
    if (!_staticCache.containsKey(key)) {
      _staticCache[key] = [];
    }
    _staticCache[key]!.add(data);

    // Issue: Creating large buffers without cleanup
    _largeDataBuffers.add(Uint8List(1024 * 1024)); // 1MB buffer
  }

  void startPeriodicTask() {
    // Issue: Creating timers that are never cleaned up
    Timer timer = Timer.periodic(Duration(seconds: 5), (t) {
      addData("periodic", DateTime.now().toString());
    });
    _timers.add(timer);
  }

  StreamController<String> createStream() {
    // Issue: Creating stream controllers that are never closed
    StreamController<String> controller = StreamController<String>();
    _controllers.add(controller);
    return controller;
  }

  // Issue: No cleanup method
}
