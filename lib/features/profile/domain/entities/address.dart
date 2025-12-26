class Address {
  const Address({
    required this.id,
    required this.name,
    required this.address,
    required this.postalCode,
    required this.isDefault,
  });

  final String id;
  final String name;
  final String address;
  final String? postalCode;
  final bool isDefault;
}
