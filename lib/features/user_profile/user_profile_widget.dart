// User Profile Widget with Circular Dependencies and Poor Structure
import 'package:flutter/material.dart';
import 'user_profile_manager.dart'; // Issue: Circular dependency

// Issue: Mixed concerns - UI widget handling business logic
class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();

  // Issue: Static method for UI updates - poor architecture
  static void updateProfile(Map<String, dynamic> data) {
    _UserProfileWidgetState.updateProfile(data);
  }
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  // Issue: Direct database access in UI widget
  static UserProfileManager? _profileManager;

  // Issue: Non-descriptive variable names
  var a, b, c;
  String x = "";
  bool y = false;

  // Issue: Hungarian notation in UI
  String strDisplayName = "";
  bool bIsEditing = false;

  @override
  void initState() {
    super.initState();
    // Issue: Direct instantiation in UI
    _profileManager = UserProfileManager();
    _loadProfileData();
  }

  // Issue: Business logic in UI layer
  void _loadProfileData() {
    // Issue: Direct data access
    if (_profileManager != null) {
      setState(() {
        strDisplayName = _profileManager!.strUserName;
      });
    }
  }

  // Issue: Static method for UI updates - poor architecture
  static void updateProfile(Map<String, dynamic> data) {
    // Issue: Static access to instance state
    if (_profileManager != null) {
      _profileManager!.mapUserData = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(strDisplayName),
    );
  }
}
