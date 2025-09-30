// Login Screen with UI/UX and Accessibility Issues
import 'package:flutter/material.dart';
import 'auth_service.dart';

// Issue: God class with mixed concerns
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Issue: Non-descriptive variable names
  final TextEditingController a = TextEditingController();
  final TextEditingController b = TextEditingController();

  // Issue: Hungarian notation
  bool bIsLoading = false;
  String strErrorMessage = "";
  int iAttemptCount = 0;

  // Issue: Direct service instantiation
  final AuthService _authService = AuthService();

  // Issue: Magic numbers
  static const int MAX_ATTEMPTS = 3;
  static const double PADDING_VALUE = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Issue: Hardcoded strings instead of localization
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Color(0xFF2196F3), // Issue: Hardcoded color
      ),
      body: _buildLoginForm(),
    );
  }

  // Issue: Long method with poor structure
  Widget _buildLoginForm() {
    return Padding(
      padding: EdgeInsets.all(PADDING_VALUE),
      child: Column(
        // Issue: Poor responsive layout
        children: [
          SizedBox(height: 50), // Issue: Hardcoded spacing

          // Issue: Missing semantic labels for accessibility
          TextField(
            controller: a, // Issue: Non-descriptive controller name
            decoration: InputDecoration(
              labelText: "Username", // Issue: Hardcoded string
              // Issue: No input validation hints
            ),
            // Issue: No input sanitization
          ),

          SizedBox(height: 20), // Issue: Hardcoded spacing

          TextField(
            controller: b,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
            ),
            // Issue: No password strength indicator
            // Issue: No accessibility labels
          ),

          SizedBox(height: 30),

          // Issue: Poor error message display
          if (strErrorMessage.isNotEmpty)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.red, // Issue: Hardcoded color, poor contrast
              child: Text(
                strErrorMessage,
                style: TextStyle(color: Colors.white),
                // Issue: No semantic role for screen readers
              ),
            ),

          SizedBox(height: 20),

          // Issue: Non-responsive button
          Container(
            width: 200, // Issue: Fixed width, not responsive
            height: 50, // Issue: Fixed height
            child: ElevatedButton(
              onPressed: bIsLoading ? null : _handleLogin,
              child: bIsLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      // Issue: No accessibility label for loading state
                    )
                  : Text("Login"),
              // Issue: No semantic label for accessibility
            ),
          ),

          SizedBox(height: 20),

          // Issue: Poor touch target size
          GestureDetector(
            onTap: _handleForgotPassword,
            child: Container(
              height: 30, // Issue: Too small touch target
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12, // Issue: Too small text
                ),
              ),
            ),
          ),

          Spacer(),

          // Issue: Biometric button with poor error handling
          FloatingActionButton(
            onPressed: _handleBiometricLogin,
            child: Icon(Icons.fingerprint),
            mini: true,
            // Issue: No accessibility label
            // Issue: No visual feedback for disabled state
          ),
        ],
      ),
    );
  }

  // Issue: Poor error handling and validation
  void _handleLogin() async {
    // Issue: No input validation
    String username = a.text;
    String password = b.text;

    // Issue: Weak validation
    if (username.isEmpty || password.isEmpty) {
      _showError("Please fill all fields"); // Issue: Hardcoded string
      return;
    }

    setState(() {
      bIsLoading = true;
      strErrorMessage = "";
    });

    try {
      // Issue: No timeout handling
      bool success = await _authService.login(username, password);

      if (success) {
        // Issue: No proper navigation management
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        iAttemptCount++;

        // Issue: Poor security - account lockout logic
        if (iAttemptCount >= MAX_ATTEMPTS) {
          _showError("Too many attempts. Account locked for 1 minute.");
          // Issue: No actual lockout implementation
        } else {
          _showError(
              "Invalid credentials. Attempt ${iAttemptCount}/${MAX_ATTEMPTS}");
        }
      }
    } catch (e) {
      // Issue: Exposing internal errors to user
      _showError("Login failed: ${e.toString()}");
    } finally {
      setState(() {
        bIsLoading = false;
      });
    }
  }

  // Issue: Biometric authentication with poor error handling
  void _handleBiometricLogin() async {
    try {
      setState(() {
        bIsLoading = true;
      });

      // Issue: No permission checks
      bool success = await _authService.authenticateWithBiometrics();

      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Issue: Generic error message
        _showError("Biometric authentication failed");
      }
    } catch (e) {
      // Issue: Poor error handling when user cancels
      if (e.toString().contains('cancelled')) {
        // Issue: Authentication flow breaks here
        _showError("Authentication cancelled");
        // Issue: Should handle cancellation gracefully
      } else {
        _showError("Biometric error: ${e.toString()}");
      }
    } finally {
      setState(() {
        bIsLoading = false;
      });
    }
  }

  void _handleForgotPassword() {
    // Issue: Missing implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Forgot Password"), // Issue: Hardcoded string
        content: Text("Feature not implemented"), // Issue: Poor UX
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    setState(() {
      strErrorMessage = message;
    });

    // Issue: No proper error logging
    print("Login error: $message");
  }

  @override
  void dispose() {
    // Issue: Missing controller disposal - memory leak
    // a.dispose(); // Commented out - causes memory leak
    // b.dispose();
    super.dispose();
  }
}

// Issue: Unused widget
class UnusedLoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
