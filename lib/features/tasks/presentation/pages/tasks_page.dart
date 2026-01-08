import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/enums/task_status.dart';
import '../../../../core/enums/task_priority.dart';
import '../bloc/tasks_bloc.dart';
import '../bloc/tasks_event.dart';
import '../bloc/tasks_state.dart';
import '../widgets/task_card.dart';
import '../widgets/add_edit_task_dialog.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

/// Tasks page showing user's tasks
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<TasksBloc>().add(LoadTasks(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                context
                    .read<TasksBloc>()
                    .add(SyncAssignmentTasks(authState.user.id));
              }
            },
            tooltip: 'Sync Assignments',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildFilters(),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTasks,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TasksLoaded) {
            final tasks = state.filteredTasks;

            if (tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_outlined,
                        size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add a new task',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(task: tasks[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<TasksBloc>(),
              child: const AddEditTaskDialog(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Status filters
          _buildFilterChip(
            'All',
            _statusFilter == null,
            () {
              setState(() => _statusFilter = null);
              context.read<TasksBloc>().add(FilterTasks(
                    status: null,
                    priority: _priorityFilter,
                  ));
            },
          ),
          ...TaskStatus.values.map((status) {
            return _buildFilterChip(
              status.displayName,
              _statusFilter == status,
              () {
                setState(() => _statusFilter = status);
                context.read<TasksBloc>().add(FilterTasks(
                      status: status,
                      priority: _priorityFilter,
                    ));
              },
            );
          }),
          const SizedBox(width: 8),
          const VerticalDivider(),
          const SizedBox(width: 8),
          // Priority filters
          ...TaskPriority.values.map((priority) {
            return _buildFilterChip(
              priority.displayName,
              _priorityFilter == priority,
              () {
                setState(() {
                  _priorityFilter =
                      _priorityFilter == priority ? null : priority;
                });
                context.read<TasksBloc>().add(FilterTasks(
                      status: _statusFilter,
                      priority: _priorityFilter,
                    ));
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
