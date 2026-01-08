import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/event_model.dart';
import '../../../../core/enums/event_status.dart';
import '../../../../core/repositories/event_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/providers/mock_user_provider.dart';

/// Page for creating a new event
class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final EventRepository _repository = EventRepository.instance;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _meetLinkController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  final List<String> _selectedTags = [];
  bool _isVirtual = false;
  bool _isSubmitting = false;

  final List<String> _availableTags = [
    'Technical',
    'Cultural',
    'Sports',
    'Workshop',
    'Seminar',
    'Hackathon',
    'Competition',
    'Exhibition',
    'Career',
    'Music',
    'Dance',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _meetLinkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one tag'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = MockUserProvider.currentUserOf(context);
      final timeString =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

      final event = EventModel(
        id: '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        time: timeString,
        location: _locationController.text.trim(),
        capacity: int.parse(_capacityController.text.trim()),
        tags: _selectedTags.map((t) => t.toLowerCase()).toList(),
        organizerId: user.id,
        organizerName: user.name,
        registeredCount: 0,
        status: EventStatus.published,
        meetLink: _isVirtual ? _meetLinkController.text.trim() : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.createEvent(event);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create event: $e'),
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
        title: const Text('Create Event'),
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
              // Event Name
              _buildSectionTitle('Event Details'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Event Name',
                hint: 'e.g., TechSprint 2026 Hackathon',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your event...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Date and Time
              _buildSectionTitle('Date & Time'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeCard(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: DateFormat('MMM dd, yyyy').format(_selectedDate),
                      onTap: _selectDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateTimeCard(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: _selectedTime.format(context),
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Location
              _buildSectionTitle('Location'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _locationController,
                label: 'Venue',
                hint: 'e.g., Main Auditorium, Block A',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Virtual event toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.videocam_outlined,
                        color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Virtual Event',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Add a Google Meet link',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isVirtual,
                      onChanged: (value) => setState(() => _isVirtual = value),
                      activeColor: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              if (_isVirtual) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _meetLinkController,
                  label: 'Meet Link',
                  hint: 'https://meet.google.com/...',
                  prefixIcon: Icons.link,
                ),
              ],
              const SizedBox(height: 24),
              // Capacity
              _buildSectionTitle('Capacity'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _capacityController,
                label: 'Maximum Attendees',
                hint: 'e.g., 100',
                prefixIcon: Icons.people_outline,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter capacity';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Tags
              _buildSectionTitle('Tags'),
              const SizedBox(height: 4),
              Text(
                'Select categories that best describe your event',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textSecondary,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.border,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Create Event',
                  onPressed: _submitEvent,
                  isLoading: _isSubmitting,
                  icon: Icons.add_circle_outline,
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

  Widget _buildDateTimeCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
