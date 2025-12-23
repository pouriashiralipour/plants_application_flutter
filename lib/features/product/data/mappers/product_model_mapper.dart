import '../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'category_model_mapper.dart';
import 'product_image_model_mapper.dart';

extension ProductModelMapper on ProductModel {
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      inventory: inventory,
      isActive: isActive,
      averageRating: averageRating,
      salesCount: salesCount,
      totalReviews: totalReviews,
      category: category.toEntity(),
      images: images.map((e) => e.toEntity()).toList(),
      mainImage: mainImage,
    );
  }
}
