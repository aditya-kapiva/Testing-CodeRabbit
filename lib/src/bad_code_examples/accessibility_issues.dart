// UI Components with Accessibility and UX Issues
import 'package:flutter/material.dart';

// Issue: Widget with multiple accessibility problems
class InaccessibleWidget extends StatefulWidget {
  @override
  _InaccessibleWidgetState createState() => _InaccessibleWidgetState();
}

class _InaccessibleWidgetState extends State<InaccessibleWidget> {
  bool _isChecked = false;
  double _sliderValue = 0.5;
  String _selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Issue: No semantic label for app bar
      appBar: AppBar(
        title: Text("Accessibility Issues"),
        backgroundColor: Color(0xFF123456), // Issue: Hardcoded color
        actions: [
          // Issue: IconButtons without semantic labels
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            // Missing: semanticLabel
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
            // Missing: semanticLabel and tooltip
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Issue: Poor color contrast
              Container(
                padding: EdgeInsets.all(16),
                color: Color(0xFFE0E0E0), // Light gray background
                child: Text(
                  "Important Information", // Issue: Light gray text on light gray background
                  style: TextStyle(
                    color: Color(0xFFC0C0C0), // Poor contrast ratio
                    fontSize: 14,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Issue: Button with poor accessibility
              Container(
                width: 100, // Issue: Fixed width, not responsive
                height: 30, // Issue: Too small touch target (should be 48x48)
                child: ElevatedButton(
                  onPressed: () {
                    print("Button pressed");
                  },
                  child: Text(
                    "Click", // Issue: Non-descriptive text
                    style: TextStyle(fontSize: 10), // Issue: Text too small
                  ),
                  // Missing: semantic label
                ),
              ),

              SizedBox(height: 20),

              // Issue: Custom checkbox without accessibility support
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: _isChecked ? Colors.blue : Colors.white,
                      ),
                      child: _isChecked
                          ? Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 8),
                    Text("Agree to terms"), // Issue: No semantic relationship
                  ],
                ),
                // Missing: Semantics widget for screen readers
              ),

              SizedBox(height: 20),

              // Issue: Slider without accessibility labels
              Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                // Missing: semantic labels for min/max values
                // Missing: value announcements
              ),

              SizedBox(height: 20),

              // Issue: Form without proper labels
              Column(
                children: [
                  // Issue: TextField without label or hint
                  TextField(
                    decoration: InputDecoration(
                      // Missing: labelText, hintText, helperText
                      border: OutlineInputBorder(),
                    ),
                    // Missing: semantic labels
                  ),

                  SizedBox(height: 16),

                  // Issue: Password field without accessibility
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    // Missing: semantic hint that this is a password field
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Issue: Image without alt text
              Image.network(
                'https://via.placeholder.com/200x100',
                // Missing: semanticLabel for screen readers
              ),

              SizedBox(height: 20),

              // Issue: Interactive elements too close together
              Row(
                children: [
                  // Issue: Touch targets too small and close
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30, // Too small
                      height: 30, // Too small
                      color: Colors.red,
                      child: Icon(Icons.delete, size: 16),
                    ),
                  ),
                  SizedBox(width: 5), // Too close
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      color: Colors.blue,
                      child: Icon(Icons.edit, size: 16),
                    ),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      color: Colors.green,
                      child: Icon(Icons.share, size: 16),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Issue: Text with insufficient contrast
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.all(16),
                child: Text(
                  "Warning message", // Issue: Yellow text on yellow background
                  style: TextStyle(
                    color: Colors.yellow[200], // Very poor contrast
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Issue: Loading indicator without accessibility
              CircularProgressIndicator(),
              // Missing: semantic label explaining what's loading

              SizedBox(height: 20),

              // Issue: Complex gesture without alternatives
              GestureDetector(
                onDoubleTap: () {
                  print("Double tap detected");
                },
                onLongPress: () {
                  print("Long press detected");
                },
                child: Container(
                  width: 200,
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      "Double tap or long press", // Issue: Complex gestures required
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Missing: Alternative interaction methods
              ),

              SizedBox(height: 20),

              // Issue: Radio buttons without proper grouping
              Column(
                children: [
                  Text(
                      "Choose an option:"), // Issue: Not associated with radio buttons
                  // Issue: Radio buttons without semantic grouping
                  RadioListTile<String>(
                    title: Text("Option 1"),
                    value: "option1",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                    // Missing: semantic hints
                  ),
                  RadioListTile<String>(
                    title: Text("Option 2"),
                    value: "option2",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value!;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Issue: Error message with poor visibility
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFFFEBEE), // Very light pink
                  border:
                      Border.all(color: Color(0xFFFFCDD2)), // Light pink border
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color(0xFFEF9A9A), // Light red - poor contrast
                      size: 16, // Too small
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This is an error message that users might not be able to see clearly",
                        style: TextStyle(
                          color: Color(0xFFEF9A9A), // Poor contrast
                          fontSize: 12, // Too small
                        ),
                      ),
                    ),
                  ],
                ),
                // Missing: semantic role as error/alert
              ),
            ],
          ),
        ),
      ),

      // Issue: FAB without semantic label
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        // Missing: tooltip and semantic label
      ),
    );
  }
}

// Issue: Custom widget without accessibility support
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      // Missing: Semantics wrapper
      // Missing: Focus handling
      // Missing: Keyboard navigation support
    );
  }
}

// Issue: Data table without accessibility
class InaccessibleDataTable extends StatelessWidget {
  final List<Map<String, String>> data = [
    {"name": "John", "age": "25", "city": "NYC"},
    {"name": "Jane", "age": "30", "city": "LA"},
    {"name": "Bob", "age": "35", "city": "Chicago"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Issue: Table headers without semantic roles
        Row(
          children: [
            Expanded(child: Text("Name")), // Missing: semantic header role
            Expanded(child: Text("Age")),
            Expanded(child: Text("City")),
          ],
        ),
        Divider(),
        // Issue: Table rows without semantic structure
        ...data
            .map((row) => Row(
                  children: [
                    Expanded(child: Text(row["name"]!)),
                    Expanded(child: Text(row["age"]!)),
                    Expanded(child: Text(row["city"]!)),
                  ],
                ))
            .toList(),
        // Missing: Semantic table structure
        // Missing: Row/column headers association
      ],
    );
  }
}

// Issue: Modal dialog with accessibility problems
class InaccessibleDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Issue: Dialog title without semantic role
            Text(
              "Confirm Action",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text("Are you sure you want to proceed?"),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Issue: Buttons without clear labels
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("No"), // Issue: Unclear button text
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Yes"), // Issue: Unclear button text
                ),
              ],
            ),
          ],
        ),
      ),
      // Missing: Semantic dialog role
      // Missing: Focus management
      // Missing: Escape key handling
    );
  }
}
