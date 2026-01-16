import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import '../../../../core/utils/page_route_utils.dart';
import '../bloc/auth_bloc.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/pages/account_page.dart';
import 'welcome_page.dart';

/// Splash/Logo page - First screen shown
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Wait for user bloc to load cached user, then check auth state
    // Navigate after 2 seconds minimum, or when user state is loaded
    Timer(const Duration(seconds: 2), () {
      if (mounted && !_hasNavigated) {
        _checkAuthAndNavigate();
      }
    });
  }

  void _checkAuthAndNavigate() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final userBloc = context.read<UserBloc>();
    final authBloc = context.read<AuthBloc>();
    final userState = userBloc.state;

    if (userState is UserLoaded && userState.userProfile != null) {
      // Restore auth state from cached user
      authBloc.add(RestoreAuthState(userState.userProfile!));
      // Navigate to account page
      Navigator.of(context).pushReplacement(
        createBlackPageRoute(const AccountPage()),
      );
    } else {
      // No cached user, go to welcome page
      Navigator.of(context).pushReplacement(
        createBlackPageRoute(const WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        // When user state is loaded, check auth and navigate
        if (state is UserLoaded && !_hasNavigated) {
          _checkAuthAndNavigate();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.black,
                Colors.grey[900]!,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo SVG
                SvgPicture.asset(
                  'assets/logo/logo_shotcaller_finalized.svg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

