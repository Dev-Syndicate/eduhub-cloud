import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/complaint_model.dart';
import '../../../../core/enums/complaint_status.dart';
import '../../../../core/enums/complaint_category.dart';
import '../../../../core/enums/complaint_priority.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../core/repositories/complaint_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/loading_shimmer.dart';
import '../../../../core/providers/mock_user_provider.dart';

/// Complaint detail page with resolution actions for admins
class ComplaintDetailPage extends StatefulWidget {
  final String complaintId;

  const ComplaintDetailPage({super.key, required this.complaintId});

  @override
  State<ComplaintDetailPage> createState() => _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends State<ComplaintDetailPage> {
  final ComplaintRepository _repository = ComplaintRepository.instance;

  ComplaintModel? _complaint;
  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadComplaint();
  }

  Future<void> _loadComplaint() async {
    setState(() => _isLoading = true);
    try {
      final complaint = await _repository.getComplaintById(widget.complaintId);
      setState(() {
        _complaint = complaint;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(ComplaintStatus newStatus, {String? notes}) async {
    if (_complaint == null) return;

    setState(() => _isUpdating = true);
    try {
      final user = MockUserProvider.currentUserOf(context);
      final updatedComplaint = await _repository.updateComplaintStatus(
        complaintId: _complaint!.id,
        status: newStatus,
        assignedToId: user.id,
        assignedToName: user.name,
        resolutionNotes: notes,
      );
      setState(() {
        _complaint = updatedComplaint;
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${newStatus.displayName}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUpdating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _rateComplaint(int rating) async {
    if (_complaint == null) return;

    setState(() => _isUpdating = true);
    try {
      final updatedComplaint = await _repository.rateComplaint(
        complaintId: _complaint!.id,
        rating: rating,
      );
      setState(() {
        _complaint = updatedComplaint;
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Thank you for your feedback!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = MockUserProvider.currentUserOf(context);
    final isAdmin = user.role == UserRole.admin || user.role == UserRole.hod;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_complaint?.complaintNumber ?? 'Complaint Details'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _complaint == null
              ? _buildErrorState()
              : _buildContent(isAdmin),
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: LoadingShimmer(height: 400),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Complaint not found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Go Back',
            onPressed: () => context.pop(),
            variant: AppButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isAdmin) {
    final complaint = _complaint!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Priority header
          Row(
            children: [
              _buildStatusChip(complaint),
              const SizedBox(width: 8),
              _buildPriorityBadge(complaint),
            ],
          ),
          const SizedBox(height: 16),
          // Category header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getCategoryColor(complaint.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(complaint.category),
                  color: _getCategoryColor(complaint.category),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.category.displayName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      complaint.complaintNumber,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Info cards
          _buildInfoCard(
            icon: Icons.person_outline,
            title: 'Submitted by',
            content: complaint.studentName,
            subtitle: complaint.studentContact,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.location_on_outlined,
            title: 'Location',
            content: complaint.location,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: 'Submitted',
            content:
                DateFormat('EEEE, MMMM dd, yyyy').format(complaint.createdAt),
            subtitle: 'at ${DateFormat('hh:mm a').format(complaint.createdAt)}',
          ),
          if (complaint.isAssigned) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.assignment_ind,
              title: 'Assigned to',
              content: complaint.assignedToName ?? 'Unknown',
            ),
          ],
          const SizedBox(height: 24),
          // Description
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              complaint.description,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Resolution notes (if resolved)
          if (complaint.resolutionNotes != null &&
              complaint.resolutionNotes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Resolution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Resolved on ${DateFormat('MMM dd, yyyy').format(complaint.resolutionDate!)}',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    complaint.resolutionNotes!,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Rating (for students if resolved)
          if (!isAdmin &&
              (complaint.status == ComplaintStatus.resolved ||
                  complaint.status == ComplaintStatus.closed)) ...[
            const SizedBox(height: 24),
            _buildRatingSection(complaint),
          ],
          // Admin actions
          if (isAdmin && complaint.status != ComplaintStatus.closed) ...[
            const SizedBox(height: 32),
            _buildAdminActions(complaint),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ComplaintModel complaint) {
    switch (complaint.status) {
      case ComplaintStatus.open:
        return const StatusChip.warning(label: 'Open');
      case ComplaintStatus.inProgress:
        return const StatusChip.info(label: 'In Progress');
      case ComplaintStatus.resolved:
        return const StatusChip.success(label: 'Resolved');
      case ComplaintStatus.closed:
        return const StatusChip.neutral(label: 'Closed');
    }
  }

  Widget _buildPriorityBadge(ComplaintModel complaint) {
    Color color;
    String label;

    switch (complaint.priority) {
      case ComplaintPriority.low:
        color = AppColors.textSecondary;
        label = 'Low Priority';
        break;
      case ComplaintPriority.medium:
        color = AppColors.warning;
        label = 'Medium Priority';
        break;
      case ComplaintPriority.high:
        color = AppColors.error;
        label = 'High Priority';
        break;
      case ComplaintPriority.critical:
        color = const Color(0xFF7C3AED);
        label = 'Critical';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(ComplaintModel complaint) {
    if (complaint.rating != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.star, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(
              'You rated this resolution: ${complaint.rating}/5',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate this resolution',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  Icons.star,
                  size: 36,
                  color: AppColors.border,
                ),
                onPressed: _isUpdating ? null : () => _rateComplaint(index + 1),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions(ComplaintModel complaint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        if (complaint.status == ComplaintStatus.open)
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Start Working',
              onPressed: () => _updateStatus(ComplaintStatus.inProgress),
              isLoading: _isUpdating,
              icon: Icons.play_arrow,
            ),
          ),
        if (complaint.status == ComplaintStatus.inProgress) ...[
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Mark Resolved',
              onPressed: () => _showResolveDialog(),
              isLoading: _isUpdating,
              icon: Icons.check,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showResolveDialog() async {
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Complaint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add resolution notes:'),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe the resolution...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Resolve'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _updateStatus(
        ComplaintStatus.resolved,
        notes: notesController.text.trim(),
      );
    }
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
