import '../../domain/entities/cart.dart';
import '../models/cart_model.dart';
import 'cart_item_model_mapper.dart';

extension CartModelMapper on CartModel {
  Cart toEntity() {
    return Cart(id: id, items: items.map((e) => e.toEntity()).toList(), totalPrice: totalPrice);
  }
}
