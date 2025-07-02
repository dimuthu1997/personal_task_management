import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_task_management/models/task_model.dart';
import 'package:personal_task_management/providers/task_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filter = 'All';
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'All', child: Text("All")),
                  const PopupMenuItem(value: 'Pending', child: Text("Pending")),
                  const PopupMenuItem(
                    value: 'Completed',
                    child: Text("Completed"),
                  ),
                ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8),
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
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('tasks')
                .orderBy('dueDate')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return const Center(child: Text("Something went wrong"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;
          var tasks =
              docs.map((doc) => TaskModel.fromMap(doc.id, doc.data())).toList();

          tasks =
              tasks.where((task) {
                final matchFilter =
                    _filter == 'All' ||
                    (_filter == 'Pending' && !task.isCompleted) ||
                    (_filter == 'Completed' && task.isCompleted);
                final matchSearch =
                    task.title.toLowerCase().contains(_search.toLowerCase()) ||
                    task.description.toLowerCase().contains(
                      _search.toLowerCase(),
                    );
                return matchFilter && matchSearch;
              }).toList();

          if (tasks.isEmpty)
            return const Center(child: Text("No tasks available"));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
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
                  onLongPress: () => _confirmDelete(context, task),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskModel task) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Task"),
            content: Text("Are you sure to delete '${task.title}'?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  provider.deleteTask(task.id);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
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
                          decoration: const InputDecoration(labelText: "Title"),
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
                                  : 'Due: ${dueDate!.toLocal().toString().split(" ")[0]}',
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
                                if (picked != null)
                                  setState(() => dueDate = picked);
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
                            dueDate == null)
                          return;

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
