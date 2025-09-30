// Mixed Quality Code - Some good practices, some issues
import 'dart:convert';

// Issue: Class mixes good and bad practices
class DataValidator {
  // Good: Private fields with proper naming
  final List<String> _validationRules;
  final Map<String, String> _errorMessages;

  // Issue: Public field that should be private
  bool debugMode = false;

  // Good: Constructor with named parameters
  DataValidator({
    List<String>? validationRules,
    Map<String, String>? errorMessages,
  })  : _validationRules = validationRules ?? [],
        _errorMessages = errorMessages ?? {};

  // Good: Well-documented method with proper return type
  /// Validates user input data
  /// Returns true if valid, false otherwise
  bool validateUserData(Map<String, dynamic> userData) {
    if (userData.isEmpty) {
      return false;
    }

    // Good: Null safety check
    String? name = userData['name'] as String?;
    if (name == null || name.trim().isEmpty) {
      return false;
    }

    // Issue: Magic number
    if (name.length < 2) {
      return false;
    }

    // Good: Proper email validation
    String? email = userData['email'] as String?;
    if (email != null && !_isValidEmail(email)) {
      return false;
    }

    return true;
  }

  // Good: Private helper method with clear purpose
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Issue: Method with poor error handling
  List<String> validateAndGetErrors(Map<String, dynamic> data) {
    List<String> errors = [];

    try {
      // Good: Structured validation
      if (!data.containsKey('name')) {
        errors.add('Name is required');
      }

      if (!data.containsKey('email')) {
        errors.add('Email is required');
      }

      // Issue: Catching all exceptions without specific handling
    } catch (e) {
      errors.add('Validation failed'); // Issue: Generic error message
    }

    return errors;
  }

  // Good: Method with clear documentation
  /// Validates a list of items with proper error collection
  /// Returns a map of item indices to their validation errors
  Map<int, List<String>> validateBatch(List<Map<String, dynamic>> items) {
    Map<int, List<String>> results = {};

    for (int i = 0; i < items.length; i++) {
      List<String> itemErrors = validateAndGetErrors(items[i]);
      if (itemErrors.isNotEmpty) {
        results[i] = itemErrors;
      }
    }

    return results;
  }

  // Issue: Method with mixed quality
  bool validateComplexData(Map<String, dynamic> data) {
    // Good: Early return pattern
    if (data.isEmpty) return false;

    // Issue: Deeply nested conditionals
    if (data.containsKey('user')) {
      var user = data['user'];
      if (user is Map) {
        if (user.containsKey('profile')) {
          var profile = user['profile'];
          if (profile is Map) {
            if (profile.containsKey('settings')) {
              // Issue: Too deep nesting
              return profile['settings'] != null;
            }
          }
        }
      }
    }

    return false;
  }

  // Good: Proper use of enums and type safety
  ValidationResult validateWithResult(Map<String, dynamic> data) {
    if (validateUserData(data)) {
      return ValidationResult.success;
    } else {
      return ValidationResult.failure;
    }
  }

  // Issue: Method that does too much
  String processAndValidateJson(String jsonString) {
    try {
      // Good: Proper JSON parsing
      Map<String, dynamic> data = json.decode(jsonString);

      // Issue: Processing and validation mixed together
      if (data.containsKey('timestamp')) {
        data['timestamp'] = DateTime.now().toIso8601String();
      }

      // Validation
      bool isValid = validateUserData(data);

      // Issue: Formatting mixed with validation
      if (isValid) {
        return json.encode(data);
      } else {
        return '{"error": "Invalid data"}';
      }
    } catch (e) {
      // Issue: Poor error handling
      return '{"error": "Processing failed"}';
    }
  }

  // Good: Proper getter method
  List<String> get validationRules => List.unmodifiable(_validationRules);

  // Issue: Setter that doesn't validate input
  set errorMessages(Map<String, String> messages) {
    // Issue: No validation of input
    _errorMessages.clear();
    _errorMessages.addAll(messages);
  }

  // Good: Method with proper documentation and error handling
  /// Adds a new validation rule
  /// Returns true if added successfully
  bool addValidationRule(String rule) {
    if (rule.trim().isEmpty) {
      return false;
    }

    if (!_validationRules.contains(rule)) {
      _validationRules.add(rule);
      return true;
    }

    return false; // Rule already exists
  }

  // Issue: Debug method that should be removed in production
  void printDebugInfo() {
    if (debugMode) {
      print('Validation rules: $_validationRules');
      print('Error messages: $_errorMessages');
    }
  }
}

// Good: Proper enum definition
enum ValidationResult {
  success,
  failure,
  partial,
}

// Issue: Class with mixed responsibilities
class DataProcessorValidator extends DataValidator {
  // Issue: Inheritance used incorrectly

  // Good: Override with proper implementation
  @override
  bool validateUserData(Map<String, dynamic> userData) {
    // Good: Call to super
    bool baseValidation = super.validateUserData(userData);

    if (!baseValidation) return false;

    // Issue: Additional processing in validator
    _processUserData(userData);

    return true;
  }

  // Issue: Processing method in validator class
  void _processUserData(Map<String, dynamic> userData) {
    // Issue: Side effects in validation
    userData['processed_at'] = DateTime.now().toIso8601String();
  }
}
