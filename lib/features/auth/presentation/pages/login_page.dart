import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'forgot_password_page.dart';

/// Login page for email/password authentication
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginFailure) {
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
                  // Logo and title
                  _buildHeader(context),
                  const SizedBox(height: 48),

                  // Login form
                  _buildLoginForm(context),
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
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.school,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'EduHub Cloud',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Sign in to your account',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final formState = state is LoginInitial ? state : const LoginInitial();

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
                context.read<LoginBloc>().add(LoginEmailChanged(value));
              },
            ),
            const SizedBox(height: 16),

            // Password field
            TextFormField(
              enabled: !isLoading,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outlined),
                errorText: formState.passwordError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<LoginBloc>().add(LoginPasswordChanged(value));
              },
            ),
            const SizedBox(height: 8),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login button
            AppButton(
              label: 'Sign In',
              onPressed: isLoading || !formState.isValid
                  ? null
                  : () {
                      context.read<LoginBloc>().add(const LoginSubmitted());
                    },
              isLoading: isLoading,
              isExpanded: true,
            ),
            const SizedBox(height: 24),

            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'OR',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.border)),
              ],
            ),
            const SizedBox(height: 24),

            // Google Sign In button
            AppButton(
              label: 'Continue with Google',
              onPressed: isLoading
                  ? null
                  : () {
                      context
                          .read<LoginBloc>()
                          .add(const LoginGoogleSubmitted());
                    },
              isLoading: isLoading,
              isExpanded: true,
              variant: AppButtonVariant.outline,
              icon: Icons.public, // Using public icon as proxy for Google/Web
            ),
          ],
        );
      },
    );
  }
}
