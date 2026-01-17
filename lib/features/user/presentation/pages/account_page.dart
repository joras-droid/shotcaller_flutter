import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/page_route_utils.dart';
import '../../../../common/widgets/app_skeleton.dart';
import '../bloc/user_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/signin_page.dart';
import 'personal_information_page.dart';
import 'files_page.dart';
import 'upload_documents_page.dart';

/// Account page with bottom navigation
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _currentIndex = 4; // Settings tab is selected

  @override
  void initState() {
    super.initState();
    // Load cached user when page is first displayed
    context.read<UserBloc>().add(const LoadCachedUser());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen to AuthBloc to save user when authenticated and handle logout
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // Save user profile to UserBloc
              context.read<UserBloc>().add(SaveUser(state.userProfile));
            } else if (state is AuthUnauthenticated) {
              // Navigate to signin page on logout
              Navigator.of(context).pushAndRemoveUntil(
                createBlackPageRoute(const SigninPage()),
                (route) => false,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Account',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded && state.userProfile != null) {
                final userProfile = state.userProfile!;
                return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Section
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: userProfile.photoUrl != null
                              ? NetworkImage(userProfile.photoUrl!)
                              : null,
                          child: userProfile.photoUrl == null
                              ? Text(
                                  userProfile.name.isNotEmpty
                                      ? userProfile.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProfile.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userProfile.email,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[800], height: 1),
                  // Menu Items
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Info',
                    onTap: () {
                      Navigator.of(context).push(
                        createBlackPageRoute(const PersonalInformationPage()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: 'My Documents',
                    onTap: () {
                      Navigator.of(context).push(
                        createBlackPageRoute(const FilesPage()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Expense List Per Load',
                    onTap: () {
                      // TODO: Navigate to expense list page
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Subscription',
                    onTap: () {
                      // TODO: Navigate to subscription page
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      // TODO: Navigate to change password page
                    },
                  ),
                  Divider(color: Colors.grey[800], height: 1),
                  // Logout
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      _handleLogout(context);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
                );
              }
              return const AppSkeleton(isFullPage: true);
            },
          ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Navigate to different tabs
            if (index == 1) {
              // Documents tab
              Navigator.of(context).push(
                createBlackPageRoute(const FilesPage()),
              );
            } else if (index == 2) {
              // Create tab
              Navigator.of(context).push(
                createBlackPageRoute(const UploadDocumentsPage()),
              );
            }
            // TODO: Implement navigation for Home (0), Loads (3), Settings (4)
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[900],
          selectedItemColor: const Color(0xFFD4A574),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              label: 'Documents',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'Loads',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Logout listener widget
class LogoutListener extends StatelessWidget {
  final Widget child;

  const LogoutListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            createBlackPageRoute(const SigninPage()),
            (route) => false,
          );
        }
      },
      child: child,
    );
  }
}

