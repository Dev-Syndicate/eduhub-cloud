import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routing/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

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
    // Create auth repository
    final authRepository = AuthRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: authRepository)
          ..add(const AuthCheckRequested()),
        child: BlocBuilder<AuthBloc, dynamic>(
          builder: (context, state) {
            final authBloc = context.read<AuthBloc>();

            return MaterialApp.router(
              title: 'EduHub Cloud',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              routerConfig: AppRouter.router(authBloc),
            );
          },
        ),
      ),
    );
  }
}
