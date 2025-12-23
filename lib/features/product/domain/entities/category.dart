class Category {
  const Category({required this.id, required this.name, required this.description});

  final String description;
  final String id;
  final String name;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description)';
  }
}
