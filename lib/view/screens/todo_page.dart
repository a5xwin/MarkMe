import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class TodoItem {
  String task;
  bool isCompleted;
  
  TodoItem({required this.task, this.isCompleted = false});
  
  Map<String, dynamic> toJson() => {
    'task': task,
    'isCompleted': isCompleted,
  };
  
  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
    task: json['task'],
    isCompleted: json['isCompleted'],
  );
}

class _TodoPageState extends State<TodoPage> {
  List<TodoItem> todoItems = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');
    if (todosJson != null) {
      final List<dynamic> todosList = json.decode(todosJson);
      setState(() {
        todoItems = todosList.map((item) => TodoItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = json.encode(todoItems.map((item) => item.toJson()).toList());
    await prefs.setString('todos', todosJson);
  }

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        todoItems.add(TodoItem(task: _taskController.text.trim()));
      });
      _taskController.clear();
      _saveTodos();
      Navigator.pop(context);
    }
  }

  void _toggleTask(int index) {
    setState(() {
      todoItems[index].isCompleted = !todoItems[index].isCompleted;
    });
    _saveTodos();
  }

  void _deleteTask(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
    _saveTodos();
  }

  int get completedTasks => todoItems.where((item) => item.isCompleted).length;
  int get totalTasks => todoItems.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'To-Do List',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.0),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '$totalTasks',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Satoshi',
                        ),
                      ),
                      const Text(
                        'Total Tasks',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757479),
                          fontFamily: 'Satoshi',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '$completedTasks',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                          fontFamily: 'Satoshi',
                        ),
                      ),
                      const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757479),
                          fontFamily: 'Satoshi',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '${totalTasks > 0 ? ((completedTasks / totalTasks * 100).round()) : 0}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0083FF),
                          fontFamily: 'Satoshi',
                        ),
                      ),
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757479),
                          fontFamily: 'Satoshi',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Satoshi',
              ),
            ),
            const SizedBox(height: 16),
            
            // Tasks List
            Expanded(
              child: todoItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks yet!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                              fontFamily: 'Satoshi',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first task',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontFamily: 'Satoshi',
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: todoItems.length,
                      itemBuilder: (context, index) {
                        final item = todoItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTaskCard(item, index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: const Color(0xFF0083FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskCard(TodoItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.0),
            offset: const Offset(-2, -2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.task,
              style: TextStyle(
                fontSize: 16,
                color: item.isCompleted ? Colors.grey[500] : Colors.white,
                fontFamily: 'Satoshi',
                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                decorationColor: Colors.grey[500],
                decorationThickness: 2,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _toggleTask(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item.isCompleted ? Colors.green : Colors.transparent,
                    border: Border.all(
                      color: item.isCompleted ? Colors.green : Colors.grey[600]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: item.isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _deleteTask(index),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Add New Task',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Satoshi',
            ),
            decoration: InputDecoration(
              hintText: 'Enter task description...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontFamily: 'Satoshi',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0083FF)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _taskController.clear();
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Satoshi',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0083FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}

// Static methods to get todo stats from anywhere
class TodoStats {
  static Future<Map<String, int>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');
    
    if (todosJson != null) {
      final List<dynamic> todosList = json.decode(todosJson);
      final List<TodoItem> todos = todosList.map((item) => TodoItem.fromJson(item)).toList();
      
      final int total = todos.length;
      final int completed = todos.where((item) => item.isCompleted).length;
      
      return {'total': total, 'completed': completed};
    }
    
    return {'total': 0, 'completed': 0};
  }
}