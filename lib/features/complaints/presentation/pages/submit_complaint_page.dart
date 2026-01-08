import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/enums/complaint_category.dart';
import '../../../../core/repositories/complaint_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/providers/mock_user_provider.dart';

/// Page for students to submit a new complaint
class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});

  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final ComplaintRepository _repository = ComplaintRepository.instance;

  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();

  ComplaintCategory? _selectedCategory;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = MockUserProvider.currentUserOf(context);

      final complaint = await _repository.createComplaint(
        studentId: user.id,
        studentName: user.name,
        studentContact: _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        category: _selectedCategory!,
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint submitted: ${complaint.complaintNumber}'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Submit Complaint'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Campus Service Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'We\'ll get back to you as soon as possible',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Category Selection
              _buildSectionTitle('Category'),
              const SizedBox(height: 4),
              Text(
                'What type of issue are you experiencing?',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              _buildCategoryGrid(),
              const SizedBox(height: 24),
              // Location
              _buildSectionTitle('Location'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _locationController,
                label: 'Where is the issue?',
                hint: 'e.g., Hostel Block C, Room 302',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Description
              _buildSectionTitle('Description'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descriptionController,
                label: 'Describe the issue',
                hint: 'Please provide as much detail as possible...',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe the issue';
                  }
                  if (value.trim().length < 20) {
                    return 'Please provide more details (at least 20 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Contact (optional)
              _buildSectionTitle('Contact (Optional)'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _contactController,
                label: 'Phone Number',
                hint: '+91 98765 43210',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Submit Complaint',
                  onPressed: _submitComplaint,
                  isLoading: _isSubmitting,
                  icon: Icons.send,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ComplaintCategory.values.map((category) {
        final isSelected = _selectedCategory == category;
        return InkWell(
          onTap: () => setState(() => _selectedCategory = category),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 30,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? _getCategoryColor(category).withOpacity(0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isSelected ? _getCategoryColor(category) : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: _getCategoryColor(category),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.displayName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? _getCategoryColor(category)
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(ComplaintCategory category) {
    switch (category) {
      case ComplaintCategory.hostel:
        return Icons.hotel;
      case ComplaintCategory.wifi:
        return Icons.wifi;
      case ComplaintCategory.canteen:
        return Icons.restaurant;
      case ComplaintCategory.maintenance:
        return Icons.build;
      case ComplaintCategory.academic:
        return Icons.school;
      case ComplaintCategory.other:
        return Icons.help_outline;
    }
  }

  Color _getCategoryColor(ComplaintCategory category) {
    switch (category) {
      case ComplaintCategory.hostel:
        return const Color(0xFF8B5CF6);
      case ComplaintCategory.wifi:
        return const Color(0xFF3B82F6);
      case ComplaintCategory.canteen:
        return const Color(0xFFF59E0B);
      case ComplaintCategory.maintenance:
        return const Color(0xFFEF4444);
      case ComplaintCategory.academic:
        return const Color(0xFF10B981);
      case ComplaintCategory.other:
        return const Color(0xFF6B7280);
    }
  }
}
