import '../../domain/entities/product_image.dart';
import '../models/product_images_model.dart';

extension ProductImageModelMapper on ProductImageModel {
  ProductImage toEntity() {
    return ProductImage(id: id, image: image, mainPicture: mainPicture);
  }
}
