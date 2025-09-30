// Legacy Task Manager - Old patterns with issues
// TODO: This file contains legacy code with multiple issues

import 'dart:convert';
import 'dart:io';

// Issue: Old-style class with deprecated patterns
class OldTaskManager {
  // Issue: Public fields without encapsulation
  List tasks = []; // Issue: No type safety
  Map config = {}; // Issue: Dynamic typing
  String status = ""; // Issue: String constants instead of enums

  // Issue: Hungarian notation from old codebase
  int iTaskCount = 0;
  String strLastError = "";
  bool bIsInitialized = false;

  // Issue: Old constructor pattern
  OldTaskManager() {
    // Issue: Constructor doing heavy work
    _loadLegacyData();
    _initializeOldSystem();
    _migrateFromXML(); // Issue: References removed XML system
  }

  // Issue: Old naming convention
  void AddTask(dynamic task) {
    // Issue: Pascal case method name
    // Issue: No validation
    tasks.add(task);
    iTaskCount++;

    // Issue: Side effects in add method
    _saveToLegacyFormat();
  }

  // Issue: Inconsistent naming
  void delete_task(int index) {
    // Issue: Snake case
    // Issue: No bounds checking
    tasks.removeAt(index);
    iTaskCount--;
  }

  void removeTask(String id) {
    // Issue: Different naming pattern
    // Issue: Inefficient search
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i]['id'] == id) {
        tasks.removeAt(i);
        break;
      }
    }
  }

  // Issue: Old-style error handling
  dynamic GetTaskById(String id) {
    // Issue: Pascal case
    try {
      for (var task in tasks) {
        if (task['id'] == id) {
          return task;
        }
      }
      return null; // Issue: Returning null instead of proper error handling
    } catch (e) {
      strLastError = e.toString(); // Issue: String error storage
      return null;
    }
  }

  // Issue: Legacy file format support
  void _loadLegacyData() {
    try {
      // Issue: Hardcoded file path
      File legacyFile = File('/data/legacy_tasks.dat');
      if (legacyFile.existsSync()) {
        String content = legacyFile.readAsStringSync();

        // Issue: Custom parsing instead of standard format
        List<String> lines = content.split('\n');
        for (String line in lines) {
          if (line.isNotEmpty) {
            List<String> parts =
                line.split('|'); // Issue: Pipe-separated format
            if (parts.length >= 3) {
              Map task = {
                'id': parts[0],
                'title': parts[1],
                'status': parts[2],
                // Issue: No validation of data integrity
              };
              tasks.add(task);
            }
          }
        }
      }
    } catch (e) {
      print("Legacy load error: $e"); // Issue: Print instead of proper logging
    }
  }

  void _saveToLegacyFormat() {
    try {
      // Issue: Blocking file I/O
      File legacyFile = File('/data/legacy_tasks.dat');
      String content = "";

      for (var task in tasks) {
        // Issue: Manual string concatenation
        content += "${task['id']}|${task['title']}|${task['status']}\n";
      }

      legacyFile.writeAsStringSync(content); // Issue: Synchronous write
    } catch (e) {
      strLastError = "Save failed: $e";
    }
  }

  // Issue: Old initialization pattern
  void _initializeOldSystem() {
    // Issue: Global state modification
    config['version'] = '1.0';
    config['format'] = 'legacy';
    config['migration_needed'] = true;

    bIsInitialized = true;
  }

  // Issue: Migration code that should have been removed
  void _migrateFromXML() {
    // Issue: References to removed XML system
    try {
      File xmlFile = File('/data/tasks.xml');
      if (xmlFile.existsSync()) {
        // Issue: XML parsing code for removed feature
        String xmlContent = xmlFile.readAsStringSync();
        // Issue: This would fail as XML support was removed
        print("Migrating from XML: $xmlContent");
      }
    } catch (e) {
      // Issue: Silent failure of migration
      strLastError = "XML migration failed";
    }
  }

  // Issue: Old-style utility methods
  String FormatDate(DateTime date) {
    // Issue: Pascal case
    // Issue: Manual date formatting
    return "${date.day}/${date.month}/${date.year}";
  }

  bool ValidateTask(dynamic task) {
    // Issue: Pascal case, dynamic parameter
    // Issue: Weak validation
    if (task == null) return false;
    if (task['title'] == null || task['title'].isEmpty) return false;
    return true;
  }

  // Issue: Old-style getters/setters
  int GetTaskCount() {
    // Issue: Pascal case
    return iTaskCount;
  }

  void SetStatus(String newStatus) {
    // Issue: Pascal case
    status = newStatus;
  }

  String GetLastError() {
    // Issue: Pascal case
    return strLastError;
  }

  // Issue: Old batch operation pattern
  void ProcessTaskBatch(List taskIds) {
    // Issue: Pascal case, no type safety
    for (var id in taskIds) {
      // Issue: No error handling in batch
      var task = GetTaskById(id.toString());
      if (task != null) {
        task['processed'] = true;
        // Issue: No validation of batch operations
      }
    }
  }

  // Issue: Legacy export format
  String ExportToLegacyFormat() {
    // Issue: Pascal case
    String result = "LEGACY_TASK_EXPORT_V1\n";
    result += "COUNT:${iTaskCount}\n";
    result += "STATUS:${status}\n";
    result += "DATA:\n";

    for (var task in tasks) {
      // Issue: Custom export format instead of standard
      result += "TASK|${task['id']}|${task['title']}|${task['status']}\n";
    }

    result += "END_EXPORT\n";
    return result;
  }

  // Issue: Old-style cleanup
  void Dispose() {
    // Issue: Pascal case
    // Issue: Incomplete cleanup
    tasks.clear();
    config.clear();
    bIsInitialized = false;
    // Issue: Not cleaning up all resources
  }
}

// Issue: Old utility class that should be refactored
class LegacyTaskUtils {
  // Issue: Static methods with old naming
  static String ConvertStatus(String oldStatus) {
    // Issue: Pascal case
    // Issue: String-based status conversion
    switch (oldStatus) {
      case "0":
        return "pending";
      case "1":
        return "active";
      case "2":
        return "done";
      default:
        return "unknown";
    }
  }

  static bool IsValidId(String id) {
    // Issue: Pascal case
    // Issue: Weak ID validation
    return id.isNotEmpty && id.length > 0;
  }

  // Issue: Old date utility
  static String GetFormattedDate(DateTime date) {
    // Issue: Pascal case
    // Issue: Hardcoded date format
    return "${date.day}-${date.month}-${date.year}";
  }
}
