import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, image, isActive];
}
