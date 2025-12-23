import 'category.dart';
import 'product_image.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.inventory,
    required this.isActive,
    required this.averageRating,
    required this.salesCount,
    required this.totalReviews,
    required this.category,
    required this.images,
    this.mainImage,
  });

  final double averageRating;
  final Category category;
  final String description;
  final String id;
  final List<ProductImage> images;
  final int inventory;
  final bool isActive;
  final String? mainImage;
  final String name;
  final int salesCount;
  final int totalReviews;

  final int price;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, inventory: $inventory, isActive: $isActive, averageRating: $averageRating, salesCount: $salesCount, totalReviews: $totalReviews, category: $category, images: ${images.length}, mainImage: $mainImage)';
  }

  ProductImage? get mainPicture {
    for (final img in images) {
      if (img.mainPicture) return img;
    }
    return null;
  }
}
