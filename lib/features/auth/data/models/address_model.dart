import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.label,
    required super.street,
    required super.city,
    super.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      street: json['street'] as String? ?? '',
      city: json['city'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  factory AddressModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return AddressModel.fromJson({
      ...data,
      'id': snapshot.id,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      label: entity.label,
      street: entity.street,
      city: entity.city,
      isDefault: entity.isDefault,
    );
  }
}
