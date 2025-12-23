class ProductImage {
  const ProductImage({required this.id, required this.image, required this.mainPicture});

  final String id;
  final String image;
  final bool mainPicture;

  @override
  String toString() {
    return 'ProductImage(id: $id, image: $image, mainPicture: $mainPicture)';
  }
}
