// UI/UX Bugs Examples
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Issue: Widget with multiple UI/UX bugs
class UIUXBugs extends StatefulWidget {
  @override
  _UIUXBugsState createState() => _UIUXBugsState();
}

class _UIUXBugsState extends State<UIUXBugs> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  int _selectedIndex = 0;
  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Issue: No back button handling
      appBar: AppBar(
        title: Text('UI/UX Bugs Demo'),
        automaticallyImplyLeading: false, // Issue: Removes back button
        backgroundColor: Color(0xFF123456), // Issue: Hardcoded color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0), // Issue: Insufficient padding
          child: Column(
            children: [
              // Issue: Form with poor UX
              _buildProblematicForm(),
              
              SizedBox(height: 10), // Issue: Inconsistent spacing
              
              // Issue: Button with poor accessibility
              _buildProblematicButton(),
              
              SizedBox(height: 15), // Issue: Different spacing value
              
              // Issue: List with performance issues
              _buildProblematicList(),
              
              SizedBox(height: 20),
              
              // Issue: Dialog trigger with poor UX
              _buildProblematicDialog(),
              
              SizedBox(height: 25), // Issue: Another different spacing
              
              // Issue: Navigation with bugs
              _buildProblematicNavigation(),
              
              // Issue: State management bugs
              _buildProblematicStateWidget(),
            ],
          ),
        ),
      ),
      // Issue: FAB with poor positioning
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Issue: No feedback to user
          print('FAB pressed'); // Issue: Only console output
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red, // Issue: Red for add action (confusing)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Issue: FAB blocks content
    );
  }
  
  // Issue: Form with multiple UX problems
  Widget _buildProblematicForm() {
    return Container(
      width: 200, // Issue: Fixed width, not responsive
      child: Column(
        children: [
          // Issue: Text field with poor UX
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter text', // Issue: Hardcoded string
              // Issue: No hint text
              // Issue: No helper text
              errorText: _errorMessage.isEmpty ? null : _errorMessage,
              border: OutlineInputBorder(),
            ),
            // Issue: No input validation
            // Issue: No character limit shown
            // Issue: No auto-correction disabled for sensitive data
            onChanged: (value) {
              // Issue: Validation on every character (poor UX)
              if (value.length < 3) {
                setState(() {
                  _errorMessage = 'Too short';
                });
              } else {
                setState(() {
                  _errorMessage = '';
                });
              }
            },
          ),
          
          SizedBox(height: 8),
          
          // Issue: Password field with problems
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              // Issue: No show/hide password toggle
              // Issue: No password strength indicator
            ),
            // Issue: No password validation
            // Issue: No caps lock warning
          ),
        ],
      ),
    );
  }
  
  // Issue: Button with poor UX
  Widget _buildProblematicButton() {
    return Container(
      width: 100, // Issue: Too narrow for text
      height: 30, // Issue: Too small touch target
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
          setState(() {
            _isLoading = true;
          });
          
          // Issue: No user feedback during loading
          await Future.delayed(Duration(seconds: 3));
          
          // Issue: Random failure without proper error handling
          if (DateTime.now().millisecond % 2 == 0) {
            // Issue: Generic error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Something went wrong'), // Issue: Vague error
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1), // Issue: Too short duration
              ),
            );
          } else {
            // Issue: Success message that disappears too quickly
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Success!'),
                duration: Duration(milliseconds: 500), // Issue: Too short
              ),
            );
          }
          
          setState(() {
            _isLoading = false;
          });
        },
        child: _isLoading 
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                // Issue: No accessibility label for loading state
              ),
            )
          : Text(
              'Submit Data Now', // Issue: Text too long for button
              style: TextStyle(fontSize: 10), // Issue: Text too small
            ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF00FF00), // Issue: Neon green, poor choice
        ),
      ),
    );
  }
  
  // Issue: List with performance and UX problems
  Widget _buildProblematicList() {
    return Container(
      height: 200,
      child: Column(
        children: [
          // Issue: Non-scrollable list in fixed height container
          ..._items.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;
            
            return Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                title: Text(item),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Issue: Buttons too close together
                    IconButton(
                      icon: Icon(Icons.edit, size: 16), // Issue: Too small
                      onPressed: () {
                        // Issue: No edit functionality
                        print('Edit $item');
                      },
                      padding: EdgeInsets.all(2), // Issue: Too small touch target
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 16),
                      onPressed: () {
                        // Issue: No confirmation dialog for destructive action
                        setState(() {
                          _items.removeAt(index);
                        });
                      },
                      padding: EdgeInsets.all(2),
                    ),
                  ],
                ),
                onTap: () {
                  // Issue: No visual feedback for tap
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selected: _selectedIndex == index,
                selectedTileColor: Colors.blue.withOpacity(0.1),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  
  // Issue: Dialog with poor UX
  Widget _buildProblematicDialog() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          // Issue: Dialog can't be dismissed by tapping outside
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // Issue: No title
              content: Container(
                width: 500, // Issue: Fixed width, not responsive
                height: 300, // Issue: Fixed height
                child: Column(
                  children: [
                    Text(
                      'This is a very long message that might not fit properly in the dialog and could cause overflow issues on smaller screens',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    
                    // Issue: Form in dialog without proper validation
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Required field',
                      ),
                      // Issue: No validation
                    ),
                    
                    Spacer(),
                    
                    Row(
                      children: [
                        // Issue: Buttons with confusing labels
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No'), // Issue: Unclear what "No" means
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Issue: No validation before closing
                            Navigator.of(context).pop();
                          },
                          child: Text('Yes'), // Issue: Unclear what "Yes" means
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('Open Dialog'),
    );
  }
  
  // Issue: Navigation with problems
  Widget _buildProblematicNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Issue: Navigation without proper state management
        GestureDetector(
          onTap: () {
            // Issue: Navigation without checking if route exists
            Navigator.pushNamed(context, '/nonexistent');
          },
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.blue,
            child: Text(
              'Go to Page',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        
        // Issue: Back navigation that might not work
        GestureDetector(
          onTap: () {
            // Issue: No check if can pop
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.red,
            child: Text(
              'Go Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  
  // Issue: State management problems
  Widget _buildProblematicStateWidget() {
    return Column(
      children: [
        Text('Counter: $_selectedIndex'),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Issue: State update without proper validation
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedIndex--; // Issue: Can go negative
                });
              },
              icon: Icon(Icons.remove),
            ),
            
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedIndex++; // Issue: Can overflow
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        
        // Issue: Gesture detector with poor feedback
        GestureDetector(
          onTap: () {
            // Issue: Haptic feedback without permission check
            HapticFeedback.vibrate();
            
            // Issue: State update that might cause issues
            setState(() {
              _selectedIndex = 0;
              _items.clear(); // Issue: Clearing list without user confirmation
            });
          },
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Reset All Data', // Issue: Destructive action without confirmation
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    // Issue: Incomplete cleanup
    _controller.dispose();
    // Issue: Other resources not cleaned up
    super.dispose();
  }
}

// Issue: Custom widget with poor implementation
class BrokenCustomWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  
  BrokenCustomWidget({required this.text, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200, // Issue: Fixed width
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis, // Issue: Text might be cut off
          ),
        ),
      ),
      // Issue: No accessibility support
      // Issue: No focus handling
      // Issue: No keyboard navigation
    );
  }
}

// Issue: Screen with orientation problems
class OrientationBugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orientation Issues'),
      ),
      body: Column(
        children: [
          // Issue: Fixed height that doesn't work in landscape
          Container(
            height: 400, // Issue: Too tall for landscape
            width: double.infinity,
            color: Colors.blue,
            child: Center(
              child: Text(
                'This container is too tall for landscape mode',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Issue: Bottom content gets cut off in landscape
          Expanded(
            child: ListView(
              children: List.generate(20, (index) => 
                ListTile(
                  title: Text('Item ${index + 1}'),
                  subtitle: Text('This content might be cut off in landscape'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
