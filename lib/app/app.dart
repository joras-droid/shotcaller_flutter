import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/user/presentation/bloc/user_bloc.dart';
import 'di/injector.dart';

/// Main app widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => getIt<UserBloc>()..add(const LoadCachedUser()),
        ),
      ],
      child: MaterialApp(
        title: 'Shotcaller App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

