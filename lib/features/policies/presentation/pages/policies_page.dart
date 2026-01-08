import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/policy_model.dart';
import '../../data/models/resource_model.dart';
import '../../data/repositories/policies_repository.dart';
import '../bloc/policies_bloc.dart';
import '../bloc/policies_event.dart';
import '../bloc/policies_state.dart';

class PoliciesPage extends StatelessWidget {
  const PoliciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PoliciesRepository(),
      child: BlocProvider(
        create: (context) => PoliciesBloc(
          repository: context.read<PoliciesRepository>(),
        )..add(const PoliciesStarted()),
        child: const _PoliciesView(),
      ),
    );
  }
}

class _PoliciesView extends StatelessWidget {
  const _PoliciesView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Policies & Resources'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Policies', icon: Icon(Icons.gavel)),
              Tab(text: 'Resources', icon: Icon(Icons.folder_shared)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PoliciesTab(),
            _ResourcesTab(),
          ],
        ),
      ),
    );
  }
}

class _PoliciesTab extends StatelessWidget {
  const _PoliciesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoliciesBloc, PoliciesState>(
      builder: (context, state) {
        if (state.status == PoliciesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == PoliciesStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.policies.isEmpty) {
          return const Center(child: Text('No policies found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: state.policies.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final policy = state.policies[index];
            return _PolicyCard(policy: policy);
          },
        );
      },
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final PolicyModel policy;

  const _PolicyCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    policy.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    policy.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              policy.summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ver: ${policy.version} • ${policy.publishedDate.year}-${policy.publishedDate.month}-${policy.publishedDate.day}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // In a real app, this would verify the URL works
                    // launchUrl(Uri.parse(policy.docUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening ${policy.title}...')),
                    );
                  },
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('View Doc'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourcesTab extends StatelessWidget {
  const _ResourcesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoliciesBloc, PoliciesState>(
      builder: (context, state) {
        if (state.status == PoliciesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == PoliciesStatus.failure) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.resources.isEmpty) {
          return const Center(child: Text('No resources found.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.resources.length,
          itemBuilder: (context, index) {
            final resource = state.resources[index];
            return _ResourceCard(resource: resource);
          },
        );
      },
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final ResourceModel resource;

  const _ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (resource.type.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'sheet':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'calendar':
        icon = Icons.calendar_month;
        color = Colors.blue;
        break;
      case 'image':
        icon = Icons.image;
        color = Colors.purple;
        break;
      default:
        icon = Icons.link;
        color = Colors.grey;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // launchUrl(Uri.parse(resource.url));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening ${resource.title}...')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                resource.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                resource.type.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
