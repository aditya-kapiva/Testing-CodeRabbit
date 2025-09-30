// Issue: Poorly named file with mixed content
// Issue: Missing proper documentation

import 'dart:convert';
import 'dart:math';

// Issue: Non-descriptive class name
class Util {
  // Issue: Non-descriptive variable names and Hungarian notation
  static String strApiUrl = "http://api.example.com";
  static int iMaxRetries = 5;
  static bool bDebugMode = true;
  static List<String> lstData = [];
  static Map<String, dynamic> mapConfig = {};

  // Issue: Magic numbers
  static const int MAGIC_NUMBER_1 = 42;
  static const int MAGIC_NUMBER_2 = 100;
  static const double MAGIC_DECIMAL = 3.14159;

  // Issue: Abbreviations instead of full names
  static String usrName = "";
  static String pwd = "";
  static String cfg = "";
  static String tmp = "";

  // Issue: Non-descriptive method names
  static void func1() {
    // Issue: Empty method body
  }

  static String func2(String a) {
    // Issue: Non-descriptive parameter name
    return a.toUpperCase();
  }

  static bool func3(int x, int y) {
    // Issue: Non-descriptive parameters and logic
    return x > y;
  }

  // Issue: Inconsistent naming - camelCase vs snake_case
  static void processData() {
    print("Processing data...");
  }

  static void process_user_info() {
    // Issue: Snake case in Dart
    print("Processing user info...");
  }

  static void ProcessConfiguration() {
    // Issue: Pascal case for method name
    print("Processing configuration...");
  }

  // Issue: Poor method naming with abbreviations
  static void calcUsrAge(int birthYr) {
    // Should be calculateUserAge(int birthYear)
    int currentYear = DateTime.now().year;
    int age = currentYear - birthYr;
    print("User age: $age");
  }

  static String getFmtdDate() {
    // Should be getFormattedDate()
    return DateTime.now().toString();
  }

  static void initCfg() {
    // Should be initializeConfiguration()
    mapConfig = {
      'timeout': 30,
      'retries': 3,
      'debug': true,
    };
  }

  // Issue: Variables with wrong prefixes
  static String _publicData =
      "This should be public"; // Private prefix but should be public
  static String publicSecret =
      "This should be private"; // No prefix but contains sensitive data

  // Issue: Overly abbreviated names
  static void prcUsrReq(Map req) {
    // Should be processUserRequest(Map request)
    if (req.containsKey('usr')) {
      String usr = req['usr'];
      print("Processing request for: $usr");
    }
  }

  // Issue: Hungarian notation
  static String strUserEmail = "";
  static int iUserCount = 0;
  static bool bIsValid = false;
  static List<String> arrUserNames = [];
  static Map<String, int> dictUserScores = {};

  // Issue: Non-English variable names (simulated)
  static String nombreUsuario = ""; // Spanish for username
  static int edadUsuario = 0; // Spanish for user age

  // Issue: Inconsistent abbreviation patterns
  static String userName = ""; // Full name
  static String usrEmail = ""; // Abbreviated
  static String u_phone = ""; // Abbreviated with underscore
  static String userPreferences = ""; // Full name
  static String usrPref = ""; // Abbreviated

  // Issue: Single letter variable names in class scope
  static var a = "";
  static var b = 0;
  static var c = false;
  static var d = [];
  static var e = {};

  // Issue: Meaningless method names
  static void doStuff() {
    // What stuff?
    print("Doing stuff...");
  }

  static void handleThing(dynamic thing) {
    // What thing? What handling?
    print("Handling thing: $thing");
  }

  static dynamic getData() {
    // What data? From where?
    return {"data": "some data"};
  }

  // Issue: Inconsistent verb usage
  static void fetchUserData() {} // Uses fetch
  static void getUserInfo() {} // Uses get
  static void retrieveUserProfile() {} // Uses retrieve
  static void obtainUserSettings() {} // Uses obtain

  // Issue: Boolean variables with poor naming
  static bool flag = false; // What flag?
  static bool check = true; // What check?
  static bool status = false; // What status?
  static bool isFlag = true; // Redundant 'is' with 'flag'

  // Issue: Collection names that don't indicate content
  static List items = []; // What items?
  static Map data = {}; // What data?
  static Set values = {}; // What values?

  // Issue: Confusing similar names
  static String userName1 = "";
  static String username = "";
  static String user_name = "";
  static String uname = "";

  // Issue: Method names that don't describe action
  static void user(String name) {
    // Verb is unclear
    usrName = name;
  }

  static String email() {
    // Missing verb - get? set? validate?
    return strUserEmail;
  }

  static bool valid() {
    // Missing context - valid what?
    return true;
  }
}

// Issue: Class name doesn't match file name
class UtilityHelper {
  // Issue: Redundant class name (Utility + Helper)

  // Issue: Method with too many single-letter parameters
  static double calc(double a, double b, double c, double d) {
    return (a + b) * c / d;
  }

  // Issue: Nested abbreviations
  static void initUsrCfgMgr() {
    // Should be initializeUserConfigurationManager()
    print("Initializing user configuration manager...");
  }
}

// Issue: Acronym overuse
class APIHTTPJSONXMLManager {
  // Issue: Too many acronyms in class name

  static void parseXMLToJSON() {
    // Issue: Acronyms without context
  }

  static void sendHTTPAPIRequest() {
    // Issue: Redundant acronyms
  }
}

// Issue: Inconsistent casing in constants
class Constants {
  static const String api_key = "key123"; // snake_case
  static const String API_SECRET = "secret456"; // SCREAMING_SNAKE_CASE
  static const String apiUrl = "http://api.com"; // camelCase
  static const String APIVERSION = "v1"; // No separator
}
