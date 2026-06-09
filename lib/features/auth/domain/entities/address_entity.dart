import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String label; // Ví dụ: Nhà riêng, Công ty
  final String street;
  final String city;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, label, street, city, isDefault];
}
