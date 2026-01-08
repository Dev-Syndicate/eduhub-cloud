import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../../data/models/drive_file_model.dart';
import '../../data/repositories/productivity_repository.dart';
import '../bloc/productivity_bloc.dart';
import '../bloc/productivity_event.dart';
import '../bloc/productivity_state.dart';

class ProductivityPage extends StatelessWidget {
  const ProductivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ProductivityRepository(),
      child: BlocProvider(
        create: (context) => ProductivityBloc(
          repository: context.read<ProductivityRepository>(),
        )..add(const ProductivityStarted()),
        child: const _ProductivityView(),
      ),
    );
  }
}

class _ProductivityView extends StatelessWidget {
  const _ProductivityView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Productivity'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Tasks', icon: Icon(Icons.check_circle_outline)),
              Tab(text: 'My Resources', icon: Icon(Icons.cloud_queue)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddTaskDialog(context),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _TasksTab(),
            _ResourcesTab(),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    // We need to pass the bloc to the dialog since it's on a different branch?
    // Actually showDialog builds in a new overlay, so we need to provide the bloc value.
    final bloc = context.read<ProductivityBloc>();

    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: const _AddTaskDialog(),
      ),
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductivityBloc, ProductivityState>(
      builder: (context, state) {
        if (state.status == ProductivityStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ProductivityStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.tasks.isEmpty) {
          return const Center(child: Text('No tasks found. Add one!'));
        }

        // Simple sorting: incomplete first, then by date
        final tasks = List<TaskModel>.from(state.tasks);
        tasks.sort((a, b) {
          if (a.isCompleted == b.isCompleted) {
            return a.dueDate.compareTo(b.dueDate);
          }
          return a.isCompleted ? 1 : -1;
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _TaskItem(task: task);
          },
        );
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final TaskModel task;

  const _TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        !task.isCompleted && task.dueDate.isBefore(DateTime.now());

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            context.read<ProductivityBloc>().add(
                  TaskStatusChanged(task, val ?? false),
                );
          },
          shape: const CircleBorder(),
          activeColor: AppColors.primaryColor,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                if (task.courseId != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.courseId!,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Icon(Icons.calendar_today,
                    size: 12, color: isOverdue ? Colors.red : Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _PriorityBadge(priority: task.priority),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        priority.toUpperCase(),
        style:
            TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ResourcesTab extends StatelessWidget {
  const _ResourcesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductivityBloc, ProductivityState>(
      builder: (context, state) {
        if (state.status == ProductivityStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ProductivityStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.driveFiles.isEmpty) {
          return const Center(child: Text('No files found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.driveFiles.length,
          itemBuilder: (context, index) {
            final file = state.driveFiles[index];
            return _DriveFileItem(file: file);
          },
        );
      },
    );
  }
}

class _DriveFileItem extends StatelessWidget {
  final DriveFileModel file;

  const _DriveFileItem({required this.file});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (file.type == 'doc') {
      icon = Icons.description;
      color = Colors.blue;
    } else if (file.type == 'sheet') {
      icon = Icons.table_chart;
      color = Colors.green;
    } else if (file.type == 'slide') {
      icon = Icons.slideshow;
      color = Colors.orange;
    } else if (file.type == 'pdf') {
      icon = Icons.picture_as_pdf;
      color = Colors.red;
    } else {
      icon = Icons.insert_drive_file;
      color = Colors.grey;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(file.name),
      subtitle: Text(
          '${file.size} • Last modified ${file.modifiedAt.day}/${file.modifiedAt.month}'),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${file.name}...')),
        );
      },
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _titleController = TextEditingController();
  String _priority = 'medium';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              hintText: 'e.g. Study for physics quiz',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _priority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: const [
              DropdownMenuItem(value: 'low', child: Text('Low')),
              DropdownMenuItem(value: 'medium', child: Text('Medium')),
              DropdownMenuItem(value: 'high', child: Text('High')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _priority = val);
            },
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _dueDate = picked);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Due Date'),
              child: Text(
                '${_dueDate.year}-${_dueDate.month}-${_dueDate.day}',
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final newTask = TaskModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                dueDate: _dueDate,
                priority: _priority,
                isCompleted: false,
                isAssignment: false,
              );
              context.read<ProductivityBloc>().add(TaskAdded(newTask));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
