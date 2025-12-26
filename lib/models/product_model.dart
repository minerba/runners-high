class ProductModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? productUrl;
  final double? price;
  final bool isFeatured;
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.productUrl,
    this.price,
    this.isFeatured = false,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      productUrl: json['product_url'] as String?,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'product_url': productUrl,
      'price': price,
      'is_featured': isFeatured,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
