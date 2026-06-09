import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String? linkAction; // Link hướng tới món ăn hoặc khuyến mãi
  final bool isActive;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    this.linkAction,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, imageUrl, linkAction, isActive];
}
