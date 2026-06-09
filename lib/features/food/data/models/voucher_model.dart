import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/voucher_entity.dart';

class VoucherModel extends VoucherEntity {
  const VoucherModel({
    required super.id,
    required super.code,
    required super.description,
    required super.discountAmount,
    required super.minOrderAmount,
    required super.expiryDate,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      description: json['description'] as String? ?? '',
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 0.0,
      expiryDate: json['expiryDate'] is Timestamp 
          ? (json['expiryDate'] as Timestamp).toDate() 
          : DateTime.tryParse(json['expiryDate'].toString()) ?? DateTime.now(),
    );
  }

  factory VoucherModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return VoucherModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountAmount': discountAmount,
      'minOrderAmount': minOrderAmount,
      'expiryDate': Timestamp.fromDate(expiryDate),
    };
  }

  factory VoucherModel.fromEntity(VoucherEntity entity) {
    return VoucherModel(
      id: entity.id,
      code: entity.code,
      description: entity.description,
      discountAmount: entity.discountAmount,
      minOrderAmount: entity.minOrderAmount,
      expiryDate: entity.expiryDate,
    );
  }
}
