// Task Manager with Functional Issues
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

// Issue: Poor data model design
class Task {
  // Issue: Public fields without validation
  int? id;
  String title = "";
  String description = "";
  DateTime? dueDate;
  bool completed = false;
  String priority = ""; // Issue: String instead of enum
  List<String> tags = [];

  // Issue: Constructor doesn't validate input
  Task(
      {this.id,
      required this.title,
      this.description = "",
      this.dueDate,
      this.completed = false});

  // Issue: Poor serialization without error handling
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed,
      'priority': priority,
      'tags': tags,
    };
  }

  // Issue: No validation in fromJson
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? "", // Issue: Silent fallback
      description: json['description'] ?? "",
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'] ?? false,
    )
      ..priority = json['priority'] ?? ""
      ..tags = List<String>.from(json['tags'] ?? []);
  }
}

// Issue: God class with mixed responsibilities
class TaskManager {
  List<Task> _tasks = [];
  SharedPreferences? _prefs;

  // Issue: Magic numbers
  static const int MAX_TASKS = 1000;
  static const String STORAGE_KEY = "tasks_data";

  // Issue: Poor initialization
  TaskManager() {
    _loadTasks();
  }

  // Issue: Blocking main thread with synchronous file operations
  void _loadTasks() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      String? tasksJson = _prefs?.getString(STORAGE_KEY);

      if (tasksJson != null) {
        // Issue: No error handling for malformed JSON
        List<dynamic> tasksList = json.decode(tasksJson);
        _tasks = tasksList.map((json) => Task.fromJson(json)).toList();
      }
    } catch (e) {
      // Issue: Silent failure - data persistence fails silently
      print("Failed to load tasks: $e");
      // Issue: No user notification of data loss
    }
  }

  // Issue: No validation and poor error handling
  Future<bool> addTask(Task task) async {
    // Issue: No input validation
    if (task.title.isEmpty) {
      return false; // Issue: Silent failure
    }

    // Issue: No duplicate checking
    task.id = _generateId();
    _tasks.add(task);

    // Issue: Data persistence fails silently when device storage is full
    try {
      await _saveTasks();
      return true;
    } catch (e) {
      // Issue: Silent failure when storage is full
      print("Storage error: $e");
      return true; // Issue: Lying about success
    }
  }

  // Issue: Functional issue - incorrectly marks overdue tasks as completed
  void completeTask(int taskId) {
    // Issue: No validation if task exists
    for (var task in _tasks) {
      if (task.id == taskId) {
        // Issue: Incorrectly marks overdue tasks as completed
        if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
          task.completed = true; // Should not allow completing overdue tasks
          print("Warning: Completing overdue task"); // Issue: Poor logging
        } else {
          task.completed = true;
        }
        _saveTasks();
        return;
      }
    }

    // Issue: No error when task not found
    print("Task not found: $taskId");
  }

  // Issue: Runtime error potential
  void deleteTask(int index) {
    // Issue: No bounds checking - will throw exception
    _tasks.removeAt(index); // Will crash if index is invalid
    _saveTasks();
  }

  // Issue: Inefficient search - case sensitive when should be case-insensitive
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;

    // Issue: Case-sensitive search
    return _tasks.where((task) {
      return task.title.contains(query) || // Should be case-insensitive
          task.description.contains(query);
    }).toList();
  }

  // Issue: Poor date validation
  bool updateTaskDueDate(int taskId, DateTime newDueDate) {
    // Issue: Allows selecting past dates for future deadlines
    // No validation for past dates

    for (var task in _tasks) {
      if (task.id == taskId) {
        task.dueDate = newDueDate; // Issue: No validation
        _saveTasks();
        return true;
      }
    }
    return false;
  }

  // Issue: Inefficient sorting
  List<Task> getTasksSortedByPriority() {
    // Issue: Inefficient sorting algorithm
    List<Task> sorted = List.from(_tasks);

    // Issue: Bubble sort - O(n²) complexity
    for (int i = 0; i < sorted.length; i++) {
      for (int j = 0; j < sorted.length - 1; j++) {
        if (_getPriorityValue(sorted[j].priority) <
            _getPriorityValue(sorted[j + 1].priority)) {
          var temp = sorted[j];
          sorted[j] = sorted[j + 1];
          sorted[j + 1] = temp;
        }
      }
    }

    return sorted;
  }

  // Issue: Magic numbers for priority
  int _getPriorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0; // Issue: Default case handling
    }
  }

  // Issue: Poor ID generation
  int _generateId() {
    // Issue: Non-unique ID generation
    return DateTime.now().millisecondsSinceEpoch ~/ 1000; // Collision prone
  }

  // Issue: Blocking file operations
  Future<void> _saveTasks() async {
    if (_prefs == null) return;

    try {
      String tasksJson =
          json.encode(_tasks.map((task) => task.toJson()).toList());

      // Issue: No check for storage space
      await _prefs!.setString(STORAGE_KEY, tasksJson);
    } catch (e) {
      // Issue: Silent failure when device storage is full
      print("Save failed: $e");
      // Issue: No user notification
    }
  }

  // Issue: Unhandled exceptions in network connectivity
  Future<void> syncWithServer() async {
    try {
      // Issue: No network connectivity check
      var client = HttpClient();

      // Issue: No timeout handling
      var request =
          await client.postUrl(Uri.parse('https://api.example.com/sync'));
      request.headers.set('content-type', 'application/json');

      // Issue: Sending all data without pagination
      request.add(utf8.encode(json.encode({
        'tasks': _tasks.map((t) => t.toJson()).toList(),
      })));

      var response = await request.close();

      if (response.statusCode == 200) {
        // Issue: Poor error recovery when API returns malformed JSON
        var responseBody = await response.transform(utf8.decoder).join();
        var data = json.decode(responseBody); // Will crash on malformed JSON

        // Issue: No validation of server response
        _tasks.clear();
        for (var taskJson in data['tasks']) {
          _tasks.add(Task.fromJson(taskJson)); // No error handling
        }

        await _saveTasks();
      }
    } catch (e) {
      // Issue: Unhandled exceptions
      print("Sync failed: $e");
      rethrow; // Issue: Propagating exceptions without handling
    }
  }

  // Issue: Memory leak in filtering
  List<Task> getFilteredTasks({String? priority, bool? completed}) {
    // Issue: Creates new lists without cleanup
    List<Task> filtered = [];

    for (var task in _tasks) {
      bool matches = true;

      if (priority != null && task.priority != priority) {
        matches = false;
      }

      if (completed != null && task.completed != completed) {
        matches = false;
      }

      if (matches) {
        filtered.add(task); // Issue: No limit on filtered results
      }
    }

    return filtered;
  }

  // Issue: Poor batch operations
  void batchUpdateTasks(List<int> taskIds, Map<String, dynamic> updates) {
    // Issue: No transaction support
    for (int id in taskIds) {
      for (var task in _tasks) {
        if (task.id == id) {
          // Issue: No validation of updates
          if (updates.containsKey('completed')) {
            task.completed = updates['completed'];
          }
          if (updates.containsKey('priority')) {
            task.priority = updates['priority']; // No validation
          }
          // Issue: Saving after each update instead of batch save
          _saveTasks();
        }
      }
    }
  }

  // Getter methods with issues
  List<Task> get tasks => _tasks; // Issue: Exposing mutable list
  int get taskCount => _tasks.length;

  // Issue: Poor validation method
  bool isValidTask(Task task) {
    // Issue: Incomplete validation
    return task.title.isNotEmpty; // Missing other validations
  }
  
  // Issue: Additional functional bugs
  
  // Issue: Incorrect date comparison
  List<Task> getOverdueTasks() {
    List<Task> overdueTasks = [];
    DateTime now = DateTime.now();
    
    for (Task task in _tasks) {
      // Issue: Using >= instead of < for overdue check
      if (task.dueDate != null && task.dueDate!.isAfter(now)) {
        overdueTasks.add(task); // Issue: Adding future tasks as overdue
      }
    }
    
    return overdueTasks;
  }
  
  // Issue: Data corruption bug
  void mergeTasks(List<Task> newTasks) {
    for (Task newTask in newTasks) {
      // Issue: Not checking for existing tasks, creates duplicates
      _tasks.add(newTask);
      
      // Issue: ID collision - multiple tasks can have same ID
      if (newTask.id == null) {
        newTask.id = _generateId(); // Issue: Modifying input parameter
      }
    }
  }
  
  // Issue: Memory leak in filtering
  List<Task> getTasksByTag(String tag) {
    // Issue: Creating new list every time, never cleaned up
    List<Task> filteredTasks = [];
    
    for (Task task in _tasks) {
      // Issue: Case-sensitive tag matching
      if (task.tags.contains(tag)) {
        // Issue: Adding reference instead of copy, can cause mutations
        filteredTasks.add(task);
      }
    }
    
    // Issue: No limit on returned results
    return filteredTasks;
  }
  
  // Issue: Race condition in batch operations
  Future<void> batchDeleteTasks(List<int> taskIds) async {
    for (int id in taskIds) {
      // Issue: Not using atomic operations
      await Future.delayed(Duration(milliseconds: 10)); // Simulate async work
      
      // Issue: Task might be deleted by another operation during delay
      _tasks.removeWhere((task) => task.id == id);
    }
    
    // Issue: Save after each deletion instead of batch save
    await _saveTasks();
  }
  
  // Issue: Incorrect statistics calculation
  Map<String, int> getTaskStatistics() {
    int completed = 0;
    int pending = 0;
    int overdue = 0;
    
    for (Task task in _tasks) {
      if (task.completed) {
        completed++;
      } else {
        pending++;
        
        // Issue: Wrong overdue calculation
        if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
          overdue++; // Issue: Counting both as pending AND overdue
        }
      }
    }
    
    return {
      'completed': completed,
      'pending': pending,
      'overdue': overdue, // Issue: Total will be wrong due to double counting
    };
  }
}
