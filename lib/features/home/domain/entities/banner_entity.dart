import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final int? priority;
  final int? price;
  final String? linkAction;
  final bool isActive;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.priority,
    this.price,
    this.linkAction,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        title,
        subtitle,
        priority,
        price,
        linkAction,
        isActive,
      ];
}
