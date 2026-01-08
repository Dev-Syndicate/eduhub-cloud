import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../../data/models/task_model.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../widgets/add_edit_task_dialog.dart';

/// Task card widget
class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<TasksBloc>(),
              child: AddEditTaskDialog(task: task),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: task.status == TaskStatus.completed,
                onChanged: task.isPersonal
                    ? (value) {
                        context.read<TasksBloc>().add(
                              ToggleTaskCompletion(task.id, value ?? false),
                            );
                      }
                    : null,
              ),
              const SizedBox(width: 12),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (task.courseName != null)
                          _buildChip(
                            task.courseName!,
                            AppColors.primaryColor,
                          ),
                        _buildChip(
                          task.priority.displayName,
                          _getPriorityColor(task.priority),
                        ),
                        if (task.dueDate != null)
                          _buildChip(
                            app_date_utils.AppDateUtils.formatDate(
                                task.dueDate!),
                            task.isOverdue
                                ? AppColors.error
                                : task.isDueSoon
                                    ? Colors.orange
                                    : AppColors.textSecondary,
                          ),
                        if (!task.isPersonal)
                          _buildChip('Assignment', AppColors.secondaryColor),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete button (only for personal tasks)
              if (task.isPersonal)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  onPressed: () {
                    _showDeleteConfirmation(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.blue;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return AppColors.error;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TasksBloc>().add(DeleteTask(task.id));
              Navigator.of(dialogContext).pop();
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
