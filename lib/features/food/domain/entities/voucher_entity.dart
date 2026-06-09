import 'package:equatable/equatable.dart';

class VoucherEntity extends Equatable {
  final String id;
  final String code;
  final String description;
  final double discountAmount;
  final double minOrderAmount;
  final DateTime expiryDate;

  const VoucherEntity({
    required this.id,
    required this.code,
    required this.description,
    required this.discountAmount,
    required this.minOrderAmount,
    required this.expiryDate,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  @override
  List<Object?> get props => [id, code, description, discountAmount, minOrderAmount, expiryDate];
}
