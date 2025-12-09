class CategoryModel {
  const CategoryModel({required this.id, required this.name, required this.description});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  final String description;
  final String id;
  final String name;

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description)';
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
