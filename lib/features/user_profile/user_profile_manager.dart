// User Profile Manager with Structural Issues
// Issue: Missing proper file documentation
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../authentication/auth_service.dart';
import '../task_management/task_manager.dart';

// Issue: Circular dependencies
import 'user_profile_widget.dart';

// Issue: God class with 500+ lines and mixed concerns
class UserProfileManager {
  // Issue: Too many responsibilities in one class
  // - User data management
  // - Network operations
  // - UI state management
  // - File operations
  // - Validation logic
  // - Caching logic

  // Issue: Non-descriptive variable names
  var a, b, c, d, e, f, g, h, i, j;
  List x = [];
  Map y = {};
  String z = "";

  // Issue: Hungarian notation
  String strUserName = "";
  String strUserEmail = "";
  int iUserAge = 0;
  bool bIsActive = false;
  List<String> lstUserPreferences = [];
  Map<String, dynamic> mapUserData = {};

  // Issue: Public variables that should be private
  String publicUserId = "";
  String publicApiKey = "";

  // Issue: Private variables that should be public
  String _userDisplayName = "";
  bool _isProfileComplete = false;

  // Issue: Direct service dependencies - tight coupling
  AuthService? authService;
  TaskManager? taskManager;
  SharedPreferences? prefs;

  // Issue: Magic numbers throughout
  static const int MAX_USERNAME_LENGTH = 50;
  static const int MIN_PASSWORD_LENGTH = 8;
  static const int CACHE_EXPIRY_HOURS = 24;
  static const int MAX_RETRY_ATTEMPTS = 3;
  static const int NETWORK_TIMEOUT = 30000;
  static const double IMAGE_MAX_SIZE = 1024.0;

  // Issue: Hardcoded configuration
  static const String API_ENDPOINT = "https://api.example.com/users";
  static const String PROFILE_CACHE_KEY = "user_profile_cache";
  static const String PREFERENCES_KEY = "user_preferences";

  // Issue: Constructor with too many responsibilities
  UserProfileManager() {
    _initializeServices();
    _loadUserData();
    _setupNetworkClient();
    _initializeCache();
    _validateConfiguration();
    _setupEventListeners();
    _loadPreferences();
    _checkPermissions();
    _initializeAnalytics();
    _setupErrorHandling();
  }

  // Issue: Long method with 50+ lines
  void _initializeServices() {
    // Issue: Direct instantiation - no dependency injection
    authService = AuthService();
    taskManager = TaskManager();

    // Issue: Blocking initialization
    _initPrefs();

    // Issue: No error handling
    publicUserId = _generateUserId();
    publicApiKey = _generateApiKey();

    // Issue: Deeply nested conditionals (5+ levels)
    if (authService != null) {
      if (authService!.isLoggedIn() != null) {
        var loginFuture = authService!.isLoggedIn();
        if (loginFuture != null) {
          loginFuture.then((isLoggedIn) {
            if (isLoggedIn) {
              if (_validateUserSession()) {
                _loadUserProfile();
              }
            }
          });
        }
      }
    }

    // Issue: Mixed concerns - UI logic in data layer
    _updateUIState();

    // Issue: More deeply nested logic
    try {
      if (prefs != null) {
        var userData = prefs!.getString('user_data');
        if (userData != null) {
          var parsedData = json.decode(userData);
          if (parsedData is Map) {
            if (parsedData.containsKey('profile')) {
              if (parsedData['profile'] != null) {
                mapUserData = parsedData['profile'];
                strUserName = mapUserData['name'] ?? '';
                strUserEmail = mapUserData['email'] ?? '';
                iUserAge = mapUserData['age'] ?? 0;
                bIsActive = mapUserData['active'] ?? false;
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _loadUserData() {
    // Issue: Another long method
    print("Loading user data...");

    // Issue: Synchronous file operations blocking main thread
    _loadFromCache();
    _loadFromNetwork();
    _loadFromDatabase();
    _validateLoadedData();
    _processUserPreferences();
    _updateUserStats();
    _syncWithServer();
    _notifyListeners();
  }

  void _setupNetworkClient() {
    // Issue: Poor network configuration
  }

  void _initializeCache() {
    // Issue: No actual implementation
  }

  void _validateConfiguration() {
    // Issue: Empty method
  }

  void _setupEventListeners() {
    // Issue: Memory leaks - listeners not properly managed
  }

  void _loadPreferences() {
    // Issue: Blocking operation
  }

  void _checkPermissions() {
    // Issue: No permission handling
  }

  void _initializeAnalytics() {
    // Issue: Privacy concerns - no user consent
  }

  void _setupErrorHandling() {
    // Issue: Global error handling in wrong place
  }

  // Issue: Inconsistent naming conventions
  Future<bool> fetchData() async {
    return true;
  }

  Future<void> get_user_info() async {
    // Issue: Snake case in Dart
  }

  void UpdateUserProfile() {
    // Issue: Pascal case for method name
  }

  bool validate_input(String input) {
    // Issue: Snake case
    return true;
  }

  // Issue: Poor method naming and abbreviations
  void usrPref() {
    // Should be userPreferences
  }

  void calcUsrData() {
    // Should be calculateUserData
  }

  Map getUserInfo() {
    // Issue: Non-descriptive return type
    return {};
  }

  // Issue: Method with too many parameters
  bool updateUserProfile(
      String name,
      String email,
      int age,
      String phone,
      String address,
      String city,
      String country,
      String zipCode,
      String company,
      String jobTitle,
      List<String> interests,
      Map<String, String> socialMedia,
      bool isPublic,
      bool allowNotifications,
      String preferredLanguage) {
    // Issue: No parameter validation
    // Issue: Too many responsibilities
    strUserName = name;
    strUserEmail = email;
    iUserAge = age;

    // Issue: Direct data manipulation without validation
    mapUserData['name'] = name;
    mapUserData['email'] = email;
    mapUserData['age'] = age;
    mapUserData['phone'] = phone;
    mapUserData['address'] = address;

    return true;
  }

  // Issue: Duplicate code across methods
  void saveUserProfile() {
    if (prefs != null) {
      String userData = json.encode(mapUserData);
      prefs!.setString('user_profile', userData);
    }
  }

  void cacheUserProfile() {
    if (prefs != null) {
      String userData = json.encode(mapUserData);
      prefs!.setString('cached_profile', userData);
    }
  }

  void backupUserProfile() {
    if (prefs != null) {
      String userData = json.encode(mapUserData);
      prefs!.setString('backup_profile', userData);
    }
  }

  // Issue: Poor error handling and validation
  bool validateUserData(Map<String, dynamic> data) {
    // Issue: Incomplete validation
    if (data.isEmpty) return false;

    // Issue: No null checks
    String name = data['name'];
    String email = data['email'];

    // Issue: Weak email validation
    if (!email.contains('@')) return false;

    return true;
  }

  // Issue: Blocking main thread with file operations
  void loadUserImage(String imagePath) {
    try {
      // Issue: Synchronous file reading
      File imageFile = File(imagePath);
      var bytes = imageFile.readAsBytesSync(); // Blocking operation

      // Issue: No image size validation
      if (bytes.length > IMAGE_MAX_SIZE * 1024) {
        print("Image too large");
      }

      // Issue: No image format validation
      String base64Image = base64Encode(bytes);
      mapUserData['profile_image'] = base64Image;
    } catch (e) {
      print("Error loading image: $e");
    }
  }

  // Issue: Poor separation of concerns - network logic in profile manager
  Future<void> uploadProfileImage(String imagePath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$API_ENDPOINT/upload-image'));

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      request.headers['Authorization'] = 'Bearer $publicApiKey';

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var json = jsonDecode(responseString);

        mapUserData['profile_image_url'] = json['url'];
        saveUserProfile();
      }
    } catch (e) {
      print("Upload failed: $e");
    }
  }

  // Issue: Mixed UI and business logic
  void _updateUIState() {
    // Issue: UI logic in data layer
    if (strUserName.isNotEmpty) {
      _userDisplayName = strUserName;
    }

    _isProfileComplete = _checkProfileCompleteness();
  }

  bool _checkProfileCompleteness() {
    // Issue: Magic numbers
    int completedFields = 0;
    int totalFields = 10;

    if (strUserName.isNotEmpty) completedFields++;
    if (strUserEmail.isNotEmpty) completedFields++;
    if (iUserAge > 0) completedFields++;

    return (completedFields / totalFields) > 0.7;
  }

  // Issue: Circular dependency methods
  void notifyProfileWidget() {
    // Issue: Tight coupling with UI
    UserProfileWidget.updateProfile(mapUserData);
  }

  // Issue: Poor caching implementation
  void _loadFromCache() {
    if (prefs != null) {
      String? cachedData = prefs!.getString(PROFILE_CACHE_KEY);
      if (cachedData != null) {
        try {
          var data = json.decode(cachedData);
          mapUserData = data;
        } catch (e) {
          print("Cache error: $e");
        }
      }
    }
  }

  void _loadFromNetwork() {
    // Issue: Network call without connectivity check
  }

  void _loadFromDatabase() {
    // Issue: Database operations in wrong layer
  }

  void _validateLoadedData() {
    // Issue: Weak validation
  }

  void _processUserPreferences() {
    // Issue: Complex processing in wrong place
  }

  void _updateUserStats() {
    // Issue: Statistics logic mixed with profile management
  }

  void _syncWithServer() {
    // Issue: Sync logic in profile manager
  }

  void _notifyListeners() {
    // Issue: Observer pattern implementation missing
  }

  // Issue: Utility methods in wrong class
  String _generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _generateApiKey() {
    return "api_key_${DateTime.now().millisecondsSinceEpoch}";
  }

  bool _validateUserSession() {
    return true;
  }

  void _loadUserProfile() {
    // Issue: Another long method
  }

  // Issue: More duplicate code
  void exportUserData() {
    String userData = json.encode(mapUserData);
    // Export logic
  }

  void importUserData(String data) {
    try {
      mapUserData = json.decode(data);
    } catch (e) {
      print("Import error: $e");
    }
  }

  // Issue: Poor resource management
  void dispose() {
    // Issue: Incomplete cleanup
    authService = null;
    taskManager = null;
    // Issue: Not disposing all resources
  }
}

// Issue: Tightly coupled utility class
class UserProfileUtils {
  // Issue: Static methods that should be instance methods
  static bool isValidEmail(String email) {
    return email.contains('@');
  }

  static String formatUserName(String name) {
    return name.trim().toLowerCase();
  }
}
