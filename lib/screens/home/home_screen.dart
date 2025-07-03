import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_task_management/models/task_model.dart';
import 'package:personal_task_management/providers/auth_provider.dart';
import 'package:personal_task_management/providers/task_provider.dart';
import 'package:personal_task_management/providers/theme_provider.dart';
import 'package:personal_task_management/screens/auth/initial_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filter = 'All';
  String _search = '';

  Future<void> _refreshTasks() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: themeProvider.toggleTheme,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );

              if (shouldLogout == true) {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const InitialScreen()),
                  );
                }
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder:
                (context) => const [
                  PopupMenuItem(value: 'All', child: Text("All")),
                  PopupMenuItem(value: 'Pending', child: Text("Pending")),
                  PopupMenuItem(value: 'Completed', child: Text("Completed")),
                ],
          ),
        ],

        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        //     ),
        //     onPressed: themeProvider.toggleTheme,
        //     tooltip: 'Toggle Theme',
        //   ),
        //   PopupMenuButton<String>(
        //     onSelected: (value) => setState(() => _filter = value),
        //     itemBuilder:
        //         (context) => [
        //           const PopupMenuItem(value: 'All', child: Text("All")),
        //           const PopupMenuItem(value: 'Pending', child: Text("Pending")),
        //           const PopupMenuItem(
        //             value: 'Completed',
        //             child: Text("Completed"),
        //           ),
        //         ],
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTasks,
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(authProvider.user?.uid)
                  .collection('tasks')
                  .orderBy('dueDate')
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var docs = snapshot.data!.docs;
            var tasks =
                docs
                    .map((doc) => TaskModel.fromMap(doc.id, doc.data()))
                    .toList();

            tasks =
                tasks.where((task) {
                  final matchFilter =
                      _filter == 'All' ||
                      (_filter == 'Pending' && !task.isCompleted) ||
                      (_filter == 'Completed' && task.isCompleted);
                  final matchSearch =
                      task.title.toLowerCase().contains(
                        _search.toLowerCase(),
                      ) ||
                      task.description.toLowerCase().contains(
                        _search.toLowerCase(),
                      );
                  return matchFilter && matchSearch;
                }).toList();

            if (tasks.isEmpty) {
              return const Center(child: Text("No tasks available"));
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Dismissible(
                  key: Key(task.id),
                  background: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Swipe right -> mark as complete/incomplete
                      final updatedTask = task.copyWith(
                        isCompleted: !task.isCompleted,
                      );
                      provider.updateTask(updatedTask);
                      return false; // Prevent Dismiss animation
                    } else if (direction == DismissDirection.endToStart) {
                      // Swipe left -> delete
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Delete Task"),
                              content: Text(
                                "Are you sure you want to delete '${task.title}'?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                      if (confirmed == true) {
                        provider.deleteTask(task.id);
                        return true; // Proceed with Dismiss animation
                      }
                    }
                    return false;
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration:
                              task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                          color: task.priorityColor,
                        ),
                      ),
                      subtitle: Text(
                        '${task.description}\nDue: ${task.dueDate.toLocal().toString().split(" ")[0]}',
                      ),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          final updatedTask = task.copyWith(isCompleted: value);
                          provider.updateTask(updatedTask);
                        },
                      ),
                      onTap: () => _showEditTaskDialog(context, task),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    _showTaskDialog(context);
  }

  void _showEditTaskDialog(BuildContext context, TaskModel task) {
    _showTaskDialog(context, editingTask: task);
  }

  void _showTaskDialog(BuildContext context, {TaskModel? editingTask}) {
    final titleController = TextEditingController(text: editingTask?.title);
    final descController = TextEditingController(
      text: editingTask?.description,
    );
    DateTime? dueDate = editingTask?.dueDate;
    String priority = editingTask?.priority ?? 'Medium';

    showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder:
                (ctx, setState) => AlertDialog(
                  title: Text(editingTask == null ? "Add Task" : "Edit Task"),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            errorText: null,
                          ),
                        ),
                        TextField(
                          controller: descController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                          ),
                        ),
                        DropdownButton<String>(
                          value: priority,
                          items:
                              ['High', 'Medium', 'Low']
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(p),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(() => priority = value!),
                        ),
                        Row(
                          children: [
                            Text(
                              dueDate == null
                                  ? 'No date'
                                  : 'Due: ${dueDate?.toLocal().toString().split(" ")[0]}',
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: ctx,
                                  initialDate: dueDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => dueDate = picked);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty ||
                            dueDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please enter a title and pick a due date.",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final task = TaskModel(
                          id: editingTask?.id ?? '',
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          dueDate: dueDate!,
                          isCompleted: editingTask?.isCompleted ?? false,
                          priority: priority,
                        );

                        final provider = Provider.of<TaskProvider>(
                          context,
                          listen: false,
                        );
                        if (editingTask != null) {
                          provider.updateTask(task);
                        } else {
                          provider.addTask(task);
                        }
                        Navigator.pop(context);
                      },
                      child: Text(editingTask == null ? "Add" : "Update"),
                    ),
                  ],
                ),
          ),
    );
  }
}
