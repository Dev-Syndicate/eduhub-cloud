import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/public_header.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PublicHeader(),
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms of Service',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Last updated: ${DateTime.now().year}',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 32),
                    _buildSection(
                      context,
                      '1. Acceptance of Terms',
                      'By accessing and using EduHub Cloud, you accept and agree to be bound by the terms and provision of this agreement.',
                    ),
                    _buildSection(
                      context,
                      '2. Use License',
                      'Permission is granted to temporarily download one copy of the materials (information or software) on EduHub Cloud for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
                    ),
                    _buildSection(
                      context,
                      '3. Disclaimer',
                      'The materials on EduHub Cloud are provided on an \'as is\' basis. EduHub Cloud makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.',
                    ),
                    _buildSection(
                      context,
                      '4. Limitations',
                      'In no event shall EduHub Cloud or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on EduHub Cloud.',
                    ),
                    _buildSection(
                      context,
                      '5. Governing Law',
                      'These terms and conditions are governed by and construed in accordance with the laws and you irrevocably submit to the exclusive jurisdiction of the courts in that location.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
