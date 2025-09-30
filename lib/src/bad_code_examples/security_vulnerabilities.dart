// Additional Security Vulnerabilities Examples
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

// Issue: Class with multiple critical security vulnerabilities
class SecurityVulnerabilities {
  // Issue: Hardcoded encryption keys
  static const String ENCRYPTION_KEY = "12345678901234567890123456789012"; // 32 bytes
  static const String IV = "1234567890123456"; // 16 bytes
  static const String DATABASE_URL = "mongodb://admin:password@localhost:27017/app";
  
  // Issue: Hardcoded JWT secrets
  static const String JWT_SECRET = "my_super_secret_key";
  static const String OAUTH_CLIENT_SECRET = "oauth_secret_12345";
  
  // Issue: Insecure random number generation for security tokens
  String generateSecurityToken() {
    Random rand = Random();
    return rand.nextInt(999999).toString().padLeft(6, '0'); // Predictable 6-digit token
  }
  
  // Issue: SQL injection vulnerability
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    // Issue: Direct string interpolation in SQL query
    String query = "SELECT * FROM users WHERE role = '$role' AND active = 1";
    print("Executing: $query"); // Issue: Logging sensitive queries
    
    // Simulated database response
    return [
      {'id': 1, 'username': 'admin', 'password': 'plaintext123'}, // Issue: Exposing passwords
    ];
  }
  
  // Issue: Command injection vulnerability
  Future<String> executeSystemCommand(String userInput) async {
    // Issue: Direct execution of user input
    ProcessResult result = await Process.run('sh', ['-c', userInput]);
    return result.stdout.toString();
  }
  
  // Issue: Path traversal vulnerability
  String readUserFile(String filename) {
    // Issue: No path validation
    String filePath = '/app/user_files/$filename';
    File file = File(filePath);
    
    try {
      return file.readAsStringSync(); // Issue: Can read any file with ../../../etc/passwd
    } catch (e) {
      return 'File not found';
    }
  }
  
  // Issue: Insecure deserialization
  dynamic deserializeUserData(String jsonData) {
    try {
      // Issue: No validation of deserialized data
      Map<String, dynamic> data = json.decode(jsonData);
      
      // Issue: Executing code from deserialized data
      if (data.containsKey('callback')) {
        String callback = data['callback'];
        // Issue: eval-like behavior (simulated)
        print("Executing callback: $callback");
      }
      
      return data;
    } catch (e) {
      return null;
    }
  }
  
  // Issue: Weak password hashing
  String hashPassword(String password) {
    // Issue: Using weak MD5 hash
    var bytes = utf8.encode(password);
    return bytes.toString(); // Issue: Not even proper MD5, just toString()
  }
  
  // Issue: Session fixation vulnerability
  String createUserSession(String username) {
    // Issue: Predictable session ID
    String sessionId = "${username}_${DateTime.now().millisecondsSinceEpoch}";
    
    // Issue: Storing session without expiry
    _sessions[sessionId] = {
      'username': username,
      'created': DateTime.now(),
      'permissions': ['read', 'write', 'admin'], // Issue: Over-privileged by default
    };
    
    return sessionId;
  }
  
  static Map<String, dynamic> _sessions = {}; // Issue: In-memory session storage
  
  // Issue: Authorization bypass
  bool hasPermission(String sessionId, String permission) {
    // Issue: Always returns true for admin check
    if (permission == 'admin') {
      return true; // Issue: Bypasses actual permission check
    }
    
    var session = _sessions[sessionId];
    if (session == null) return false;
    
    List<String> permissions = session['permissions'] ?? [];
    return permissions.contains(permission);
  }
  
  // Issue: Information disclosure
  Map<String, dynamic> getUserProfile(String userId) {
    return {
      'id': userId,
      'username': 'user123',
      'email': 'user@example.com',
      'password': 'plaintext123', // Issue: Exposing password in profile
      'ssn': '123-45-6789', // Issue: Exposing SSN
      'credit_card': '4111-1111-1111-1111', // Issue: Exposing credit card
      'internal_notes': 'User flagged for suspicious activity', // Issue: Internal data exposed
      'api_keys': ['key1', 'key2', 'key3'], // Issue: Exposing API keys
    };
  }
  
  // Issue: Insecure HTTP requests
  Future<String> sendSensitiveData(String data) async {
    try {
      // Issue: Sending sensitive data over HTTP (not HTTPS)
      var response = await http.post(
        Uri.parse('http://external-api.com/data'), // Issue: HTTP not HTTPS
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $JWT_SECRET', // Issue: Exposing JWT secret
        },
        body: json.encode({
          'sensitive_data': data,
          'user_credentials': {
            'username': 'admin',
            'password': 'admin123', // Issue: Hardcoded credentials in request
          },
        }),
      );
      
      return response.body;
    } catch (e) {
      // Issue: Exposing internal error details
      return 'Error: ${e.toString()}';
    }
  }
  
  // Issue: XML External Entity (XXE) vulnerability simulation
  String processXmlData(String xmlData) {
    // Issue: No XXE protection (simulated)
    if (xmlData.contains('<!ENTITY')) {
      // Issue: Processing external entities
      return 'Processing XML with external entities...';
    }
    return 'XML processed';
  }
  
  // Issue: Cross-site scripting (XSS) vulnerability
  String renderUserContent(String userInput) {
    // Issue: No HTML encoding/sanitization
    return '<div>User said: $userInput</div>'; // Issue: Direct injection of user input
  }
  
  // Issue: Insecure file upload
  bool uploadFile(String filename, List<int> fileData) {
    // Issue: No file type validation
    // Issue: No file size limits
    // Issue: Executable files allowed
    
    String uploadPath = '/uploads/$filename'; // Issue: No path sanitization
    File file = File(uploadPath);
    
    try {
      file.writeAsBytesSync(fileData);
      
      // Issue: Executing uploaded files
      if (filename.endsWith('.sh') || filename.endsWith('.exe')) {
        Process.run(uploadPath, []); // Issue: Executing uploaded files
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Issue: Race condition in security check
  bool _isSecurityCheckInProgress = false;
  
  Future<bool> performSecurityCheck(String userId) async {
    // Issue: Race condition vulnerability
    if (_isSecurityCheckInProgress) {
      return true; // Issue: Bypasses security check if already in progress
    }
    
    _isSecurityCheckInProgress = true;
    
    // Simulate security check
    await Future.delayed(Duration(seconds: 2));
    
    _isSecurityCheckInProgress = false;
    return true;
  }
  
  // Issue: Timing attack vulnerability
  bool authenticateUser(String username, String password) {
    String storedPassword = _getStoredPassword(username);
    
    // Issue: Timing attack - early return reveals information
    if (storedPassword.isEmpty) {
      return false; // Issue: Returns immediately if user doesn't exist
    }
    
    // Issue: Character-by-character comparison allows timing attacks
    for (int i = 0; i < password.length && i < storedPassword.length; i++) {
      if (password[i] != storedPassword[i]) {
        return false; // Issue: Early return reveals position of mismatch
      }
    }
    
    return password.length == storedPassword.length;
  }
  
  String _getStoredPassword(String username) {
    // Simulated password storage
    Map<String, String> passwords = {
      'admin': 'admin123',
      'user': 'password',
    };
    return passwords[username] ?? '';
  }
  
  // Issue: Insecure cryptographic implementation
  String encryptData(String plaintext) {
    // Issue: XOR encryption with fixed key (easily breakable)
    String key = 'SECRET';
    String encrypted = '';
    
    for (int i = 0; i < plaintext.length; i++) {
      int charCode = plaintext.codeUnitAt(i);
      int keyChar = key.codeUnitAt(i % key.length);
      encrypted += String.fromCharCode(charCode ^ keyChar);
    }
    
    return base64Encode(utf8.encode(encrypted));
  }
  
  // Issue: Privilege escalation vulnerability
  void updateUserRole(String userId, String newRole, String currentUserRole) {
    // Issue: No proper authorization check
    if (currentUserRole == 'user') {
      // Issue: Users can escalate their own privileges
      print('Updating user $userId to role: $newRole');
      // Update logic here
    }
  }
}
