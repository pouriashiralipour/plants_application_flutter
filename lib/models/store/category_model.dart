import 'product_model.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.products,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      products: (json['products'] as List? ?? []).map((e) => ProductModel.fromJson(e)).toList(),
    );
  }

  final String description;
  final String id;
  final String name;
  final List<ProductModel>? products;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'products': products?.map((e) => e.toJson()).toList(),
    };
  }
}
