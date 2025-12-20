class AddressModel {
  const AddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      postalCode: json['postal_code']?.toString(),
      isDefault: json['is_default'] == true,
    );
  }

  final String address;
  final String id;
  final bool isDefault;
  final String name;
  final String? postalCode;

  Map<String, dynamic> toCreateJson() {
    return {'name': name, 'address': address, 'postal_code': postalCode, 'is_default': isDefault}
      ..removeWhere((k, v) => v == null);
  }
}
