// Authentication Service with Security Issues
// TODO: Security issue - Multiple vulnerabilities in this file

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Issue: Hardcoded API keys and secrets
class AuthService {
  // TODO: Security issue - Hardcoded credentials
  static const String API_KEY =
      "sk_live_51234567890abcdef"; // Hardcoded API key
  static const String SECRET_KEY =
      "whsec_abcd1234efgh5678"; // Hardcoded webhook secret
  static const String DATABASE_PASSWORD =
      "admin123!@#"; // Hardcoded DB password
  static const String JWT_SECRET =
      "super_secret_jwt_key_2023"; // Hardcoded JWT secret

  // Issue: Weak default credentials
  static const String DEFAULT_ADMIN_USER = "admin";
  static const String DEFAULT_ADMIN_PASS = "password123";

  // Issue: Exposed debug information
  static const bool ENABLE_DEBUG_AUTH = true;
  static const String DEBUG_TOKEN = "debug_token_12345";

  SharedPreferences? _prefs;

  // Issue: Constructor doesn't handle initialization errors
  AuthService() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    // Issue: No error handling
    _prefs = await SharedPreferences.getInstance();
  }

  // Issue: Weak authentication logic
  Future<bool> login(String username, String password) async {
    // Issue: No input sanitization
    print(
        "Login attempt: $username / $password"); // Issue: Logging sensitive data

    // Issue: Weak validation
    if (username.isEmpty || password.isEmpty) {
      return false;
    }

    // Issue: Hardcoded authentication bypass
    if (username == DEFAULT_ADMIN_USER && password == DEFAULT_ADMIN_PASS) {
      await _storeCredentials(username, password);
      return true;
    }

    // Issue: Debug authentication bypass
    if (ENABLE_DEBUG_AUTH && password == "debug") {
      print(
          "DEBUG: Authentication bypassed!"); // Issue: Debug info in production
      return true;
    }

    // Issue: Weak password validation
    if (password.length < 3) {
      // Should be much stronger
      return false;
    }

    try {
      // Issue: No SSL pinning, insecure HTTP
      var response = await http.post(
        Uri.parse(
            'http://insecure-api.com/auth'), // Issue: HTTP instead of HTTPS
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': API_KEY, // Issue: Exposing API key in headers
        },
        body: json.encode({
          'username': username,
          'password': password, // Issue: Sending password in plain text
          'api_secret': SECRET_KEY, // Issue: Exposing secret
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Issue: No validation of response data
        await _storeCredentials(username, password);
        await _storeToken(data['token']);
        return true;
      }
    } catch (e) {
      // Issue: Poor error handling, exposing internal errors
      print("Auth error: ${e.toString()}");
      return false;
    }

    return false;
  }

  // TODO: Security issue - Plain text storage
  Future<void> _storeCredentials(String username, String password) async {
    if (_prefs == null) return;

    // Issue: Storing credentials in plain text
    await _prefs!.setString('username', username);
    await _prefs!
        .setString('password', password); // Critical: Plain text password
    await _prefs!.setString('last_login', DateTime.now().toString());

    // Issue: Storing sensitive data without encryption
    await _prefs!.setString(
        'user_profile',
        json.encode({
          'username': username,
          'password': password, // Duplicating sensitive data
          'api_key': API_KEY,
          'secret': SECRET_KEY,
        }));
  }

  Future<void> _storeToken(String token) async {
    if (_prefs == null) return;

    // Issue: Token stored without encryption or expiry check
    await _prefs!.setString('auth_token', token);
    await _prefs!.setString('token_created', DateTime.now().toString());
    // Issue: No token expiry handling
  }

  // Issue: Biometric authentication with poor error handling
  Future<bool> authenticateWithBiometrics() async {
    try {
      // Issue: Missing actual biometric implementation
      // This will break when user cancels biometric prompt
      await Future.delayed(Duration(seconds: 2));

      // Issue: Random failure simulation without proper handling
      if (DateTime.now().millisecond % 3 == 0) {
        throw Exception("Biometric authentication cancelled");
      }

      return true;
    } catch (e) {
      // Issue: Poor error recovery
      print("Biometric auth failed: $e");
      return false; // Should handle cancellation differently
    }
  }

  Future<String?> getStoredUsername() async {
    if (_prefs == null) await _initPrefs();

    // Issue: No null safety
    return _prefs!.getString('username');
  }

  Future<String?> getStoredPassword() async {
    if (_prefs == null) await _initPrefs();

    // Issue: Returning plain text password
    return _prefs!.getString('password');
  }

  Future<bool> isLoggedIn() async {
    if (_prefs == null) await _initPrefs();

    String? token = _prefs!.getString('auth_token');

    // Issue: No token validation or expiry check
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    if (_prefs == null) await _initPrefs();

    // Issue: Incomplete logout - not clearing all sensitive data
    await _prefs!.remove('auth_token');
    // Issue: Leaving username and password in storage
  }

  // Issue: Insecure password reset
  Future<bool> resetPassword(String email) async {
    // Issue: No email validation
    if (email.isEmpty) return false;

    try {
      // Issue: Sending sensitive data over HTTP
      var response = await http.post(
        Uri.parse('http://insecure-api.com/reset-password'),
        body: {
          'email': email,
          'api_key': API_KEY, // Issue: Exposing API key
          'reset_token': _generateWeakToken(), // Issue: Weak token generation
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Issue: Weak token generation
  String _generateWeakToken() {
    // Issue: Predictable token generation
    return "reset_${DateTime.now().millisecondsSinceEpoch}";
  }

  // Issue: SQL injection vulnerability simulation
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    // Issue: Direct SQL injection vulnerability
    String query =
        "SELECT * FROM users WHERE id = '$userId'"; // Vulnerable to injection

    print("Executing query: $query"); // Issue: Logging sensitive queries

    // Simulated database response with sensitive data
    return {
      'id': userId,
      'password_hash': 'weak_md5_hash', // Issue: Weak hashing algorithm
      'api_keys': [API_KEY, SECRET_KEY], // Issue: Exposing secrets
      'credit_card': '4111-1111-1111-1111', // Issue: Storing PCI data
    };
  }

  // Issue: Missing input validation
  bool validateInput(String input) {
    // Issue: No actual validation
    return true;
  }

  // Issue: Insecure random number generation
  String generateSessionId() {
    // Issue: Weak randomness
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Issue: Additional security vulnerabilities

  // Issue: Password reset with security flaws
  Future<String> generatePasswordResetToken(String email) async {
    // Issue: Token based on predictable data
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String token = "${email}_reset_$timestamp";

    // Issue: Storing reset token without expiry
    await _prefs!.setString('reset_token_$email', token);

    // Issue: No rate limiting on password reset requests
    return token;
  }

  // Issue: Privilege escalation vulnerability
  Future<bool> elevateUserPrivileges(
      String userId, String requestedRole) async {
    // Issue: No proper authorization check
    String? currentUser = await getStoredUsername();

    // Issue: Any logged-in user can elevate privileges
    if (currentUser != null) {
      await _prefs!.setString('user_role_$userId', requestedRole);
      return true;
    }

    return false;
  }

  // Issue: Session hijacking vulnerability
  Future<void> storeSessionData(
      String sessionId, Map<String, dynamic> data) async {
    // Issue: Session data stored in plain text
    String sessionData = json.encode(data);
    await _prefs!.setString('session_$sessionId', sessionData);

    // Issue: No session expiry
    // Issue: No session invalidation on logout
  }

  // Issue: Information disclosure
  Future<Map<String, dynamic>> getDebugInfo() async {
    // Issue: Exposing sensitive debug information in production
    return {
      'api_key': API_KEY,
      'secret_key': SECRET_KEY,
      'database_password': DATABASE_PASSWORD,
      'jwt_secret': JWT_SECRET,
      'stored_credentials': {
        'username': await getStoredUsername(),
        'password': await getStoredPassword(), // Issue: Exposing password
      },
      'debug_mode': ENABLE_DEBUG_AUTH,
      'system_info': {
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
      }
    };
  }

  // Issue: Timing attack vulnerability in token validation
  bool validateResetToken(String email, String providedToken) {
    String? storedToken = _prefs?.getString('reset_token_$email');

    if (storedToken == null) {
      return false; // Issue: Early return reveals information
    }

    // Issue: Character-by-character comparison allows timing attacks
    if (storedToken.length != providedToken.length) {
      return false; // Issue: Early return based on length
    }

    for (int i = 0; i < storedToken.length; i++) {
      if (storedToken[i] != providedToken[i]) {
        return false; // Issue: Early return reveals position
      }
    }

    return true;
  }

  // Issue: Insecure direct object reference
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    // Issue: No access control - any user can access any user's data
    return {
      'id': userId,
      'username': 'user_$userId',
      'email': 'user$userId@example.com',
      'personal_data': {
        'ssn': '123-45-$userId',
        'phone': '555-0$userId',
        'address': '$userId Main St',
      },
      'financial_data': {
        'account_balance': 1000.00,
        'credit_score': 750,
        'bank_account': '12345$userId',
      }
    };
  }

  // Issue: Cross-site request forgery (CSRF) vulnerability
  Future<bool> updateUserEmail(String newEmail) async {
    // Issue: No CSRF token validation
    // Issue: No email verification
    await _prefs!.setString('user_email', newEmail);
    return true;
  }

  // Issue: Account enumeration vulnerability
  Future<String> checkUserExists(String username) async {
    // Issue: Different responses reveal if user exists
    Map<String, String> users = {
      'admin': 'exists',
      'user1': 'exists',
      'test': 'exists',
    };

    if (users.containsKey(username)) {
      return 'User exists'; // Issue: Confirms user existence
    } else {
      return 'User not found'; // Issue: Confirms user doesn't exist
    }
  }

  // Issue: Weak cryptographic implementation
  String encryptSensitiveData(String data) {
    // Issue: ROT13 "encryption" (easily breakable)
    String encrypted = '';
    for (int i = 0; i < data.length; i++) {
      int char = data.codeUnitAt(i);
      if (char >= 65 && char <= 90) {
        encrypted += String.fromCharCode((char - 65 + 13) % 26 + 65);
      } else if (char >= 97 && char <= 122) {
        encrypted += String.fromCharCode((char - 97 + 13) % 26 + 97);
      } else {
        encrypted += data[i];
      }
    }
    return encrypted;
  }
}
