import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/app_skeleton.dart';
import '../bloc/user_bloc.dart';
import 'truck_type_page.dart';
import 'others_page.dart';

/// Personal Information page with tabs
class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  int _selectedTab = 0; // 0: Basic Info, 1: Truck Type, 2: Others

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Personal Information',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            // child: const Text(
            //   '85%',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 12,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded && state.userProfile != null) {
            final userProfile = state.userProfile!;
            return Column(
              children: [
                // Profile Picture
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[800]!, width: 2),
                      ),
                      child: ClipOval(
                        child: userProfile.photoUrl != null
                            ? Image.network(
                                userProfile.photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildDefaultAvatar(userProfile),
                              )
                            : _buildDefaultAvatar(userProfile),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      _buildTab('Basic Info', 0),
                      const SizedBox(width: 24),
                      _buildTab('Truck Type', 1),
                      const SizedBox(width: 24),
                      _buildTab('Others', 2),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Content based on selected tab
                Expanded(
                  child: _selectedTab == 0
                      ? _buildBasicInfo(userProfile)
                      : _selectedTab == 1
                          ? const TruckTypePage()
                          : const OthersPage(),
                ),
              ],
            );
          }
          return const AppSkeleton(isFullPage: true);
        },
      ),
    );
  }

  Widget _buildDefaultAvatar(userProfile) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Text(
          userProfile.name.isNotEmpty
              ? userProfile.name[0].toUpperCase()
              : 'U',
          style: const TextStyle(
            fontSize: 48,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              color: isSelected ? Colors.white : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(userProfile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fill all personal information',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoField('Full Name', userProfile.name),
          const SizedBox(height: 24),
          _buildInfoField('Email', userProfile.email),
          const SizedBox(height: 24),
          _buildInfoField('Phone Number', userProfile.phone ?? 'Not set'),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Save changes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Changes saved'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A574),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Divider(color: Colors.grey[800], height: 1),
      ],
    );
  }
}

