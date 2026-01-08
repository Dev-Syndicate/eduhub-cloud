import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/enums/policy_category.dart';
import '../bloc/policies_bloc.dart';
import '../bloc/policies_event.dart';
import '../bloc/policies_state.dart';
import '../widgets/policy_card.dart';
import 'policy_detail_page.dart';

/// Policies page showing list of campus policies
class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  final TextEditingController _searchController = TextEditingController();
  PolicyCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<PoliciesBloc>().add(const LoadPolicies());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Policies & Documents'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              _buildSearchBar(),
              _buildCategoryFilters(),
            ],
          ),
        ),
      ),
      body: BlocBuilder<PoliciesBloc, PoliciesState>(
        builder: (context, state) {
          if (state is PoliciesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PoliciesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading policies',
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
                    onPressed: () {
                      context.read<PoliciesBloc>().add(const LoadPolicies());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PoliciesLoaded) {
            if (state.policies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined,
                        size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(
                      'No policies found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.policies.length,
              itemBuilder: (context, index) {
                final policy = state.policies[index];
                return PolicyCard(
                  policy: policy,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<PoliciesBloc>(),
                          child: PolicyDetailPage(policy: policy),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search policies...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<PoliciesBloc>()
                        .add(const ClearPoliciesSearch());
                  },
                )
              : null,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            context.read<PoliciesBloc>().add(SearchPolicies(value));
          } else {
            context.read<PoliciesBloc>().add(const ClearPoliciesSearch());
          }
        },
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('All', null),
          ...PolicyCategory.values.map((category) {
            return _buildCategoryChip(category.displayName, category);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, PolicyCategory? category) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });

          if (category == null) {
            context.read<PoliciesBloc>().add(const LoadPolicies());
          } else {
            context
                .read<PoliciesBloc>()
                .add(LoadPoliciesByCategory(category));
          }
        },
      ),
    );
  }
}
