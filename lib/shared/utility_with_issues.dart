// Utility file with various code quality issues
// TODO: Documentation issue - incomplete and outdated comments

import 'dart:convert';
import 'dart:io';
import 'dart:math';

/*
 * Old utility class for handling user data
 * Created: 2020-01-01
 * Last updated: Never
 * TODO: This comment describes removed functionality
 * Used to handle XML parsing but now we use JSON
 */

// Issue: God class with too many responsibilities
class UtilityWithIssues {
  // Issue: Magic numbers without explanation
  static const int TIMEOUT = 5000;
  static const int MAX_RETRIES = 3;
  static const double CONVERSION_FACTOR = 2.54;
  static const int BUFFER_SIZE = 1024;
  static const int STATUS_CODE = 200;

  // Issue: Deeply nested conditionals (5+ levels)
  static bool validateUserInput(Map<String, dynamic> input) {
    if (input != null) {
      if (input.containsKey('user')) {
        if (input['user'] != null) {
          var user = input['user'];
          if (user is Map) {
            if (user.containsKey('name')) {
              if (user['name'] != null) {
                if (user['name'].toString().isNotEmpty) {
                  return true;
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  // Issue: Long method with 50+ lines and multiple responsibilities
  static Future<Map<String, dynamic>> processUserData(
      String userId,
      Map<String, dynamic> userData,
      List<String> permissions,
      bool validateData,
      bool saveToCache,
      bool sendNotification) async {
    // Issue: No input validation
    print("Processing user data for: $userId");

    Map<String, dynamic> result = {};
    List<String> errors = [];

    // Issue: Complex nested logic
    try {
      if (validateData) {
        if (userData.containsKey('name')) {
          String name = userData['name'];
          if (name.length < 2) {
            errors.add("Name too short");
          } else if (name.length > 50) {
            errors.add("Name too long");
          } else {
            // Issue: More nesting
            if (name.contains(RegExp(r'[0-9]'))) {
              errors.add("Name contains numbers");
            } else {
              if (!name.contains(RegExp(r'^[a-zA-Z\s]+$'))) {
                errors.add("Name contains invalid characters");
              }
            }
          }
        }

        if (userData.containsKey('email')) {
          String email = userData['email'];
          if (!email.contains('@')) {
            errors.add("Invalid email format");
          } else {
            if (!email.contains('.')) {
              errors.add("Invalid email domain");
            } else {
              // Issue: Poor email validation
              if (email.split('@').length != 2) {
                errors.add("Invalid email structure");
              }
            }
          }
        }

        if (userData.containsKey('age')) {
          var age = userData['age'];
          if (age is int) {
            if (age < 0) {
              errors.add("Age cannot be negative");
            } else if (age > 150) {
              errors.add("Age too high");
            }
          } else {
            errors.add("Age must be a number");
          }
        }
      }

      // Issue: File operations blocking main thread
      if (saveToCache) {
        String cacheDir = "/tmp/user_cache";
        Directory dir = Directory(cacheDir);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }

        File cacheFile = File("$cacheDir/$userId.json");
        String jsonData = json.encode(userData);
        cacheFile.writeAsStringSync(jsonData); // Blocking operation
      }

      // Issue: Network operations without proper error handling
      if (sendNotification) {
        var client = HttpClient();
        var request = await client
            .postUrl(Uri.parse('https://api.notifications.com/send'));
        request.headers.set('content-type', 'application/json');
        request.add(utf8.encode(json.encode({
          'userId': userId,
          'message': 'Profile updated',
          'timestamp': DateTime.now().toIso8601String(),
        })));
        var response = await request.close();
        // Issue: No response handling
      }

      result['success'] = errors.isEmpty;
      result['errors'] = errors;
      result['processedAt'] = DateTime.now().toIso8601String();
    } catch (e) {
      // Issue: Poor error handling
      print("Error processing user data: $e");
      result['success'] = false;
      result['errors'] = ['Processing failed'];
    }

    return result;
  }

  // Issue: Duplicate code across methods
  static String formatDate1(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatDate2(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  static String formatDate3(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Issue: Poor null safety
  static String processString(String? input) {
    // Issue: No null check
    return input!.toUpperCase(); // Will crash if input is null
  }

  static int calculateAge(DateTime? birthDate) {
    // Issue: No null check
    return DateTime.now().year - birthDate!.year; // Will crash if null
  }

  // Issue: Inefficient algorithms
  static List<int> bubbleSort(List<int> list) {
    // Issue: O(n²) sorting when Dart has efficient built-in sort
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list.length - 1; j++) {
        if (list[j] > list[j + 1]) {
          int temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
    return list;
  }

  // Issue: Memory leaks in data processing
  static List<String> processLargeDataset(List<Map<String, dynamic>> data) {
    List<String> results = [];
    List<String> tempStorage = []; // Issue: Never cleared

    for (var item in data) {
      // Issue: Creating many intermediate objects
      String processed = json.encode(item);
      tempStorage.add(processed);
      results.add(processed);

      // Issue: No memory management for large datasets
    }

    // Issue: tempStorage is never cleared - memory leak
    return results;
  }

  // Issue: Inconsistent error handling
  static dynamic parseJson(String jsonString) {
    try {
      return json.decode(jsonString);
    } catch (e) {
      return null; // Issue: Silent failure
    }
  }

  static Map<String, dynamic> parseJsonWithLogging(String jsonString) {
    try {
      return json.decode(jsonString);
    } catch (e) {
      print("JSON parsing failed: $e"); // Issue: Different error handling
      throw e; // Issue: Inconsistent with above method
    }
  }

  // Issue: Methods with side effects not indicated in name
  static String getUserName(String userId) {
    // Issue: Method name suggests read-only but has side effects
    print("Accessing user: $userId"); // Side effect: logging
    _updateLastAccessed(userId); // Side effect: updating state
    return "User_$userId";
  }

  static void _updateLastAccessed(String userId) {
    // Issue: Side effect in what appears to be a getter
    print("Last accessed updated for: $userId");
  }

  // Issue: Poor input validation
  static double divide(double a, double b) {
    // Issue: No division by zero check
    return a / b; // Will return Infinity or NaN
  }

  static String substring(String text, int start, int end) {
    // Issue: No bounds checking
    return text.substring(start, end); // Will crash with invalid indices
  }

  // Issue: Hardcoded values
  static bool isValidPassword(String password) {
    // Issue: Hardcoded validation rules
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }

  // Issue: Poor performance with string concatenation
  static String buildLargeString(List<String> parts) {
    String result = "";
    // Issue: Inefficient string concatenation in loop
    for (String part in parts) {
      result += part; // Creates new string object each time
      result += " ";
    }
    return result;
  }

  // Issue: Resource leaks
  static String readFileContent(String filePath) {
    // Issue: File not properly closed
    File file = File(filePath);
    return file.readAsStringSync(); // No try-catch, no resource management
  }

  // Issue: Poor random number usage
  static String generateId() {
    // Issue: Weak random number generation
    Random rand = Random();
    return rand.nextInt(1000).toString(); // Predictable, collision-prone
  }

  // Issue: Missing input sanitization
  static String buildSqlQuery(String tableName, String whereClause) {
    // Issue: SQL injection vulnerability
    return "SELECT * FROM $tableName WHERE $whereClause";
  }

  // Issue: Poor date handling
  static bool isDateInFuture(String dateString) {
    // Issue: No date format validation
    DateTime date = DateTime.parse(dateString); // Will crash on invalid format
    return date.isAfter(DateTime.now());
  }

  // Issue: Inconsistent return types
  static dynamic getValue(String key) {
    if (key == "number") return 42;
    if (key == "string") return "hello";
    if (key == "bool") return true;
    if (key == "list") return [1, 2, 3];
    return null; // Issue: Inconsistent return types make it hard to use
  }
}

// Issue: Commented out code that should be removed
/*
class OldUtilityClass {
  static void oldMethod() {
    print("This method is no longer used");
  }
  
  static String formatOldDate(DateTime date) {
    return date.toString();
  }
}
*/

// Issue: Dead code - unused class
class UnusedUtilityClass {
  static void unusedMethod() {
    print("This is never called");
  }

  static const String UNUSED_CONSTANT = "never used";
}

// Issue: Poor constant organization
const int RANDOM_NUMBER = 42;
const String SOME_STRING = "hello";
const bool SOME_FLAG = true;
const double PI_APPROXIMATE = 3.14;
