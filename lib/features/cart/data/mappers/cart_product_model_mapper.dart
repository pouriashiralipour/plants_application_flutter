import '../../domain/entities/cart_product.dart';
import '../models/cart_model.dart';

extension CartProductModelMapper on CartProductModel {
  CartProduct toEntity() {
    return CartProduct(id: id, name: name, price: price, image: image);
  }
}
