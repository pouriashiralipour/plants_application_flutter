class WishlistProduct {
  const WishlistProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.categoryName,
    required this.averageRating,
    required this.salesCount,
  });

  final double averageRating;
  final String categoryName;
  final String id;
  final String image;
  final String name;
  final int price;
  final int salesCount;
}
