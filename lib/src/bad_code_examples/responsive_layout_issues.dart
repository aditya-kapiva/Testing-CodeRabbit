// Responsive Layout and Platform Issues
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

// Issue: Non-responsive layout
class NonResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Non-Responsive Layout"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Issue: Fixed width containers
            Container(
              width: 400, // Issue: Fixed width, won't work on smaller screens
              height: 200, // Issue: Fixed height
              color: Colors.blue,
              child: Center(
                child: Text(
                  "Fixed Size Container",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24, // Issue: Fixed font size
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Issue: Row that will overflow on small screens
            Row(
              children: [
                Container(width: 150, height: 100, color: Colors.red),
                Container(width: 150, height: 100, color: Colors.green),
                Container(width: 150, height: 100, color: Colors.blue),
                Container(width: 150, height: 100, color: Colors.yellow),
                // Issue: Total width = 600, will overflow on most phones
              ],
            ),

            SizedBox(height: 20),

            // Issue: Hardcoded padding that doesn't scale
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 50), // Too much on small screens
              child: Column(
                children: [
                  // Issue: Fixed width text fields
                  SizedBox(
                    width: 300, // Fixed width
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Fixed Width Input",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Issue: Buttons with fixed dimensions
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Fixed Size Button"),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Issue: Grid with fixed cross-axis count
            Container(
              height: 300,
              child: GridView.count(
                crossAxisCount:
                    4, // Issue: Always 4 columns regardless of screen size
                children: List.generate(20, (index) {
                  return Container(
                    margin: EdgeInsets.all(4),
                    color: Colors.primaries[index % Colors.primaries.length],
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, // Issue: Fixed font size
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Issue: Platform-specific code without proper checks
class PlatformSpecificIssues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Platform Issues"),
        // Issue: Using iOS-style back button on all platforms
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), // iOS-specific icon
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Issue: Using platform-specific code without checks
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              // Issue: Assuming iOS without checking
              Platform.isIOS
                  ? "iOS Content"
                  : "Android Content", // Will crash on web
            ),
          ),

          // Issue: iOS-specific UI patterns on all platforms
          Container(
            height: 200,
            child: ListView(
              children: [
                // Issue: iOS-style list tiles on all platforms
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Setting 1"),
                      Spacer(),
                      Icon(Icons.chevron_right), // iOS-style chevron
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Setting 2"),
                      Spacer(),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Issue: Android-specific navigation without adaptation
          ElevatedButton(
            onPressed: () {
              // Issue: Using Android-style navigation drawer concepts
              Scaffold.of(context).openDrawer(); // Assumes drawer exists
            },
            child: Text("Open Drawer (Android-style)"),
          ),

          // Issue: Hardcoded status bar height
          Container(
            height: 24, // Issue: Assumes specific status bar height
            color: Colors.black,
            child: Center(
              child: Text(
                "Status Bar Overlay",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Issue: Tablet layout not considered
class TabletUnfriendlyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tablet Unfriendly"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16), // Issue: Same padding for all screen sizes
        child: Column(
          children: [
            // Issue: Single column layout that wastes tablet space
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Content Area",
                    style: TextStyle(
                      fontSize: 18, // Issue: Same font size for all screens
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "This content could be displayed in multiple columns on tablets, "
                    "but it's forced into a single column layout that doesn't utilize "
                    "the available screen space effectively.",
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Issue: Button bar that doesn't adapt to larger screens
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Button 1"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Button 2"),
                  ),
                ),
              ],
            ),
            // Issue: Buttons will be very wide on tablets

            SizedBox(height: 20),

            // Issue: List that doesn't use tablet space efficiently
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('$index'),
                      ),
                      title: Text('Item $index'),
                      subtitle: Text('Subtitle for item $index'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  );
                },
                // Issue: Single column list wastes tablet screen space
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Issue: No breakpoint handling
class NoBreakpointWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("No Breakpoints"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Issue: No responsive breakpoints
            Text(
              "Screen width: ${screenWidth.toStringAsFixed(0)}",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 20),

            // Issue: Same layout for all screen sizes
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue[100],
              child: Center(
                child: Text(
                  "This container looks the same on phone, tablet, and desktop",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Issue: Form that doesn't adapt to screen size
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Field 1",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Field 2",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Field 3",
                    border: OutlineInputBorder(),
                  ),
                ),
                // Issue: Could be arranged in multiple columns on larger screens
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Issue: Orientation not handled
class OrientationIssues extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orientation Issues"),
      ),
      body: Column(
        children: [
          // Issue: Fixed height that doesn't work in landscape
          Container(
            height: 400, // Issue: Too tall in landscape mode
            width: double.infinity,
            color: Colors.green[100],
            child: Center(
              child: Text("Fixed Height Container"),
            ),
          ),

          // Issue: Bottom content gets cut off in landscape
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("This content might get cut off in landscape mode"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Button"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
