class ProductImageModel {
  final String id;
  final String image;
  final bool mainPicture;

  const ProductImageModel({required this.id, required this.image, required this.mainPicture});

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id']?.toString() ?? '',
      image: json['image'] ?? '',
      mainPicture: json['main_picture'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'main_picture': mainPicture};
  }
}
