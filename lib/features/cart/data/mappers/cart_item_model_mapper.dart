import '../../domain/entities/cart_item.dart';
import '../models/cart_model.dart';
import 'cart_product_model_mapper.dart';

extension CartItemModelMapper on CartItemModel {
  CartItem toEntity() {
    return CartItem(id: id, product: product.toEntity(), quantity: quantity, itemPrice: itemPrice);
  }
}
