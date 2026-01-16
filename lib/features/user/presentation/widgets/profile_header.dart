import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// Profile header widget
class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeader({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          backgroundImage: userProfile.photoUrl != null
              ? NetworkImage(userProfile.photoUrl!)
              : null,
          child: userProfile.photoUrl == null
              ? Text(
                  userProfile.name.isNotEmpty
                      ? userProfile.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          userProfile.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          userProfile.email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

