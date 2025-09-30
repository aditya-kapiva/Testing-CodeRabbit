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
}
