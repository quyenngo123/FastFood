import 'package:equatable/equatable.dart';

/// Đối tượng User thuần túy — không phụ thuộc Firebase hay bất kỳ thư viện nào
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? fullName;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    required this.email,
    this.fullName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, email, fullName, photoUrl];
}