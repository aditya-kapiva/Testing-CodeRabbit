// Task List Screen with Performance and UX Issues
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'task_manager.dart';

// Issue: God class with mixed concerns
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Issue: Direct service instantiation
  final TaskManager _taskManager = TaskManager();

  // Issue: Non-descriptive variable names
  List<Task> a = [];
  String b = "";
  bool c = false;
  int d = 0;

  // Issue: Hungarian notation
  bool bIsLoading = true;
  String strSearchQuery = "";
  List<Task> lstFilteredTasks = [];

  // Issue: Magic numbers
  static const double ITEM_HEIGHT = 120.0;
  static const int ITEMS_PER_PAGE = 50;

  // Issue: Memory leaks - controllers not disposed
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
    // Issue: No error handling for initialization
  }

  // Issue: Blocking main thread
  void _loadTasks() {
    setState(() {
      bIsLoading = true;
    });

    // Issue: Synchronous operation on main thread
    a = _taskManager.tasks;
    lstFilteredTasks = a;

    setState(() {
      bIsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Issue: Hardcoded strings
      appBar: AppBar(
        title: Text("Tasks"),
        backgroundColor: Colors.blue, // Issue: Hardcoded color
        actions: [
          // Issue: No accessibility labels
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: _syncTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          if (c) _buildSearchBar(),
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: Icon(Icons.add),
        // Issue: No semantic label
      ),
    );
  }

  // Issue: Poor search implementation
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16), // Issue: Hardcoded padding
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search tasks...", // Issue: Hardcoded string
          prefixIcon: Icon(Icons.search),
          // Issue: No accessibility hints
        ),
        onChanged: (query) {
          setState(() {
            strSearchQuery = query;
            // Issue: Case-sensitive search
            lstFilteredTasks = _taskManager.searchTasks(query);
          });
        },
      ),
    );
  }

  // Issue: Inefficient list rendering with large datasets
  Widget _buildTaskList() {
    if (bIsLoading) {
      return Center(
        child: CircularProgressIndicator(),
        // Issue: No accessibility label for loading
      );
    }

    if (lstFilteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64, // Issue: Hardcoded size
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "No tasks found", // Issue: Hardcoded string
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Issue: No virtualization for large lists
    return ListView.builder(
      controller: _scrollController,
      // Issue: Renders all items at once - performance problem
      itemCount: lstFilteredTasks.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(lstFilteredTasks[index], index);
      },
    );
  }

  // Issue: Complex widget with memory leaks
  Widget _buildTaskItem(Task task, int index) {
    return Container(
      height: ITEM_HEIGHT,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _editTask(task),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Issue: Memory leak in image loading
              _buildTaskImage(task),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        _buildPriorityChip(task.priority),
                        Spacer(),
                        if (task.dueDate != null)
                          Text(
                            _formatDate(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: task.dueDate!.isBefore(DateTime.now())
                                  ? Colors.red // Issue: Poor color contrast
                                  : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  // Issue: No accessibility labels
                  Checkbox(
                    value: task.completed,
                    onChanged: (value) =>
                        _toggleTaskCompletion(task.id!, index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                    // Issue: No confirmation dialog
                    // Issue: No accessibility label
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Issue: Memory leaks in image loading components
  Widget _buildTaskImage(Task task) {
    // Issue: Loading images for every task item
    return Container(
      width: 60,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          // Issue: Hardcoded image URL
          imageUrl: "https://via.placeholder.com/60x60",
          fit: BoxFit.cover,
          // Issue: No error handling for failed image loads
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: Icon(Icons.error),
          ),
          // Issue: No loading placeholder
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color chipColor;
    // Issue: Hardcoded colors
    switch (priority.toLowerCase()) {
      case 'high':
        chipColor = Colors.red;
        break;
      case 'medium':
        chipColor = Colors.orange;
        break;
      case 'low':
        chipColor = Colors.green;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Issue: Poor date formatting
  String _formatDate(DateTime date) {
    // Issue: No localization
    return "${date.day}/${date.month}/${date.year}";
  }

  void _toggleSearch() {
    setState(() {
      c = !c;
      if (!c) {
        _searchController.clear();
        strSearchQuery = "";
        lstFilteredTasks = a;
      }
    });
  }

  // Issue: Unhandled exceptions in network operations
  void _syncTasks() async {
    try {
      setState(() {
        bIsLoading = true;
      });

      // Issue: No network connectivity check
      await _taskManager.syncWithServer();

      // Issue: No error handling for sync failures
      _loadTasks();

      // Issue: No user feedback for successful sync
    } catch (e) {
      // Issue: Poor error handling
      print("Sync failed: $e");
      // Issue: No user notification of failure
    } finally {
      setState(() {
        bIsLoading = false;
      });
    }
  }

  void _toggleTaskCompletion(int taskId, int index) {
    // Issue: Functional issue - using TaskManager's broken method
    _taskManager.completeTask(taskId); // This has the overdue task bug

    setState(() {
      // Issue: Direct state manipulation
      lstFilteredTasks[index].completed = !lstFilteredTasks[index].completed;
    });
  }

  void _deleteTask(int index) {
    // Issue: No confirmation dialog
    // Issue: Using broken delete method
    _taskManager.deleteTask(index); // This can crash with invalid index

    setState(() {
      lstFilteredTasks.removeAt(index);
    });
  }

  void _addNewTask() {
    // Issue: Missing implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Task"), // Issue: Hardcoded string
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

  void _editTask(Task task) {
    // Issue: Missing implementation
    print("Edit task: ${task.title}");
  }

  @override
  void dispose() {
    // Issue: Memory leaks - not disposing controllers
    // _searchController.dispose(); // Commented out
    // _scrollController.dispose(); // Commented out
    super.dispose();
  }
}

// Issue: Unused class
class TaskItemWidget extends StatelessWidget {
  final Task task;

  TaskItemWidget({required this.task});

  @override
  Widget build(BuildContext context) {
    // Issue: Dead code - this widget is never used
    return Container();
  }
}
