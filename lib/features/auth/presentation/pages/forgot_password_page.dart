import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';

/// Forgot password page for password reset
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password reset email sent! Please check your inbox.',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Navigate back after showing success message
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  });
                } else if (state is ForgotPasswordFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(context),
                  const SizedBox(height: 32),

                  // Form
                  _buildForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        // Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.lock_reset,
            color: AppColors.primaryColor,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          'Forgot Password?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoading;
        final formState = state is ForgotPasswordInitial
            ? state
            : const ForgotPasswordInitial();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email field
            TextFormField(
              enabled: !isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Icons.email_outlined),
                errorText: formState.emailError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context
                    .read<ForgotPasswordBloc>()
                    .add(ForgotPasswordEmailChanged(value));
              },
            ),
            const SizedBox(height: 24),

            // Send reset email button
            AppButton(
              label: 'Send Reset Email',
              onPressed: isLoading || !formState.isValid
                  ? null
                  : () {
                      context
                          .read<ForgotPasswordBloc>()
                          .add(const ForgotPasswordSubmitted());
                    },
              isLoading: isLoading,
              isExpanded: true,
            ),
            const SizedBox(height: 16),

            // Back to login button
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              child: const Text('Back to Login'),
            ),
          ],
        );
      },
    );
  }
}
