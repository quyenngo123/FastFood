import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.fullName,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      ...data,
      'uid': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      fullName: entity.fullName,
      photoUrl: entity.photoUrl,
    );
  }
}
