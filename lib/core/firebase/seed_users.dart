import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/food/data/datasources/user_data.dart';

class SeedUsers {
  static Future<void> uploadUsers() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Starting to upload users...');
      for (final user in UserData.users) {
        await firestore
            .collection('users')
            .doc(user['uid'] as String)
            .set({
          'uid': user['uid'],
          'name': user['name'],
          'email': user['email'],
          'phone': user['phone'],
          'avatar': user['avatar'],
          'address': user['address'],
          'role': user['role'],
          'isActive': user['isActive'],
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('Uploaded User: ${user['name']}');
      }
      print('======================');
      print('USERS UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('USERS UPLOAD ERROR: $e');
    }
  }
}
