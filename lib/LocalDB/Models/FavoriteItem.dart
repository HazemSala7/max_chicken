class FavoriteItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final String name;
  final String image;
  final double price;

  FavoriteItem({
    this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
    };
  }

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
    );
  }

  FavoriteItem copyWith({
    int? id,
    int? productId,
    String? name,
    String? image,
    double? price,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
    );
  }
}
