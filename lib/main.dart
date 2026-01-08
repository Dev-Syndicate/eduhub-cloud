import 'package:flutter/material.dart';
import 'core/providers/mock_user_provider.dart';
import 'core/routing/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/enums/user_role.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap with MockUserProvider for development
    return MockUserProvider(
      currentUser: MockUsers.getUserByRole(UserRole.student),
      child: MaterialApp.router(
        title: 'EduHub Cloud',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
