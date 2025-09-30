// Task Manager App with Intentional Issues
// TODO: Documentation issue - Missing proper file documentation
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/authentication/auth_service.dart';
import 'features/task_management/task_manager.dart';
import 'shared/poorly_named_files.dart';

// Issue: Exposed debug information in production
const bool DEBUG_MODE = true;
// Security issue: Hardcoded API configuration
const String API_BASE_URL = "http://unsecure-api.com";
const String API_KEY = "hardcoded_key_12345"; // TODO: Security issue

void main() {
  // Issue: Missing error handling for main function
  runApp(MyApp());
}

// Issue: Non-descriptive class name
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager', // Issue: Hardcoded string instead of localization
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Issue: Direct instantiation without dependency injection
      home: TaskManagerHomePage(),
      // Issue: Missing error handling
      debugShowCheckedModeBanner: DEBUG_MODE, // Exposed in production
    );
  }
}

// God class issue: This will grow to 500+ lines
class TaskManagerHomePage extends StatefulWidget {
  TaskManagerHomePage({Key? key}) : super(key: key);

  @override
  _TaskManagerHomePageState createState() => _TaskManagerHomePageState();
}

// Issue: Mixing concerns - UI, business logic, and data access all in one class
class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  // Issue: Non-descriptive variable names
  var a = 0;
  var x = "";
  List data = []; // Issue: No type safety
  
  // Issue: Hungarian notation
  String strUserName = "";
  int iCount = 0;
  bool bIsLoading = false;
  
  // Issue: Public variables with private prefix
  String _publicData = "should be public";
  
  // Issue: Magic numbers
  static const int MAGIC_NUMBER = 42;
  
  // Issue: Direct database access in UI layer
  SharedPreferences? prefs;
  TaskManager? taskManager;
  AuthService? authService;

  @override
  void initState() {
    super.initState();
    // Issue: Blocking main thread with synchronous operations
    _loadData();
    // Issue: No error handling
    _initializeServices();
  }

  // Issue: Long method with 50+ lines (this will be expanded)
  void _loadData() async {
    // Issue: No null safety check
    prefs = await SharedPreferences.getInstance();
    
    // Issue: Deeply nested conditionals (5+ levels)
    if (prefs != null) {
      if (prefs!.containsKey('user_data')) {
        var userData = prefs!.getString('user_data');
        if (userData != null) {
          if (userData.isNotEmpty) {
            if (userData.length > 10) {
              // Issue: Plain text storage of sensitive data
              strUserName = userData;
              setState(() {
                bIsLoading = false;
              });
            } else {
              print("User data too short"); // Issue: Using print instead of proper logging
            }
          }
        }
      }
    }
    
    // Issue: Unhandled exception potential
    var networkData = await _fetchNetworkData();
    data = networkData;
    
    // Issue: Magic number usage
    if (data.length > MAGIC_NUMBER) {
      // Do something
    }
  }

  // Issue: Missing error handling and poor naming
  Future<List> _fetchNetworkData() async {
    // Issue: No SSL pinning, no input validation
    // This method will throw unhandled exceptions
    throw Exception("Network error - unhandled");
  }

  void _initializeServices() {
    // Issue: Direct instantiation, tight coupling
    authService = AuthService();
    taskManager = TaskManager();
  }

  // Issue: Inconsistent naming convention
  void fetchData() {
    // Issue: Empty method body
  }
  
  void get_user_info() {
    // Issue: Snake case in Dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Issue: Hardcoded string
      appBar: AppBar(
        title: Text("Task Manager"),
        backgroundColor: Colors.blue, // Issue: Hardcoded color
      ),
      body: bIsLoading 
        ? CircularProgressIndicator() // Issue: No accessibility label
        : _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        // Issue: No semantic label for accessibility
      ),
    );
  }

  // Issue: Poor separation of concerns
  Widget _buildTaskList() {
    return ListView.builder(
      // Issue: Inefficient rendering for large datasets
      itemCount: data.length,
      itemBuilder: (context, index) {
        // Issue: No null safety
        var task = data[index];
        return ListTile(
          title: Text(task.toString()), // Issue: Poor error handling
          onTap: () {
            // Issue: Direct state manipulation
            setState(() {
              a++; // Issue: Non-descriptive variable
            });
          },
        );
      },
    );
  }

  void _addTask() {
    // Issue: No input validation
    // Issue: Missing implementation
    print("Add task clicked"); // Issue: Debug print in production
  }

  @override
  void dispose() {
    // Issue: Missing cleanup, potential memory leaks
    super.dispose();
  }
}

// Issue: Commented out code that should be removed
/*
class OldTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/

// Issue: Dead code
class UnusedClass {
  void unusedMethod() {
    // This class is never used
  }
}
