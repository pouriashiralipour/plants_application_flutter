// models/product/product_model.dart
import 'category_model.dart';
import 'product_images_model.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.inventory,
    required this.isActive,
    required this.averageRating,
    required this.salesCount,
    required this.category,
    required this.images,
    this.mainImage,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      inventory: (json['inventory'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] ?? true,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
      category: CategoryModel.fromJson(json['category'] ?? {}),
      images: (json['images'] as List? ?? []).map((e) => ProductImageModel.fromJson(e)).toList(),
      mainImage: json['image'] ?? json['main_image'],
    );
  }

  final double averageRating;
  final CategoryModel category;
  final String description;
  final String id;
  final List<ProductImageModel> images;
  final int inventory;
  final bool isActive;
  final String? mainImage;
  final String name;
  final int price;
  final int salesCount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'inventory': inventory,
      'is_active': isActive,
      'average_rating': averageRating,
      'sales_count': salesCount,
      'category': category.toJson(),
      'images': images.map((e) => e.toJson()).toList(),
      'image': mainImage,
    };
  }
}
