import '../../../product/data/models/product_model.dart';

class WishlistItemModel {
  final String id;
  final ProductModel product;

  const WishlistItemModel({required this.id, required this.product});

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id']?.toString() ?? '',
      product: ProductModel.fromJson(Map<String, dynamic>.from(json['product'] ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'product': product.toJson()};
  }
}
