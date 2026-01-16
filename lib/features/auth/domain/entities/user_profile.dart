import 'package:equatable/equatable.dart';

/// User profile entity
/// Represents the user profile data stored in cache
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final bool? emailVerified;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.emailVerified,
  });

  /// Convert to JSON map for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
    };
  }

  /// Create from JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool?,
    );
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    bool? emailVerified,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, photoUrl, emailVerified];
}

