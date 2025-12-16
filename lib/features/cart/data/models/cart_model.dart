import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';

class CartProductModel {
  const CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  final String id;
  final String name;
  final int price;
  final String image;

  int get displayPrice => price ~/ 10;

  String get formattedDisplayPrice => '${displayPrice.toString().priceFormatter} تومان'.farsiNumber;

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0) as int,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'image': image};
  }
}

class CartItemModel {
  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.itemPrice,
  });

  final String id;
  final CartProductModel product;
  final int quantity;
  final int itemPrice;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      product: CartProductModel.fromJson(
        Map<String, dynamic>.from(json['product'] ?? <String, dynamic>{}),
      ),
      quantity: (json['quantity'] ?? 0) as int,
      itemPrice: (json['item_price'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'product': product.toJson(), 'quantity': quantity, 'item_price': itemPrice};
  }
}

class CartModel {
  const CartModel({required this.id, required this.items, required this.totalPrice});

  final String id;
  final List<CartItemModel> items;
  final int totalPrice;

  int get displaytotalPrice => totalPrice ~/ 10;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id']?.toString() ?? '',
      items: (json['items'] as List? ?? const [])
          .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      totalPrice: (json['total_price'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'items': items.map((e) => e.toJson()).toList(), 'total_price': totalPrice};
  }
}
