import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/public_header.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                      'Privacy Policy',
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
                      '1. Introduction',
                      'Welcome to EduHub Cloud. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you as to how we look after your personal data when you visit our website and tell you about your privacy rights and how the law protects you.',
                    ),
                    _buildSection(
                      context,
                      '2. Data We Collect',
                      'We may collect, use, store and transfer different kinds of personal data about you which we have grouped together follows:\n\n• Identity Data includes first name, last name, username or similar identifier.\n• Contact Data includes email address and telephone numbers.\n• Technical Data includes internet protocol (IP) address, your login data, browser type and version.\n• Usage Data includes information about how you use our website and services.',
                    ),
                    _buildSection(
                      context,
                      '3. How We Use Your Data',
                      'We will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances:\n\n• Where we need to perform the contract we are about to enter into or have entered into with you.\n• Where it is necessary for our legitimate interests (or those of a third party) and your interests and fundamental rights do not override those interests.\n• Where we need to comply with a legal or regulatory obligation.',
                    ),
                    _buildSection(
                      context,
                      '4. Data Security',
                      'We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed.',
                    ),
                    _buildSection(
                      context,
                      '5. Contact Us',
                      'If you have any questions about this privacy policy or our privacy practices, please contact us.',
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
