class CartItem {
  final int? id;
  final int productId; // Unique identifier for the product
  final String name;
  final String image;
  final double price;
  int quantity;
  int user_id;

  CartItem(
      {this.id,
      required this.productId,
      required this.name,
      required this.image,
      required this.price,
      required this.user_id,
      this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'user_id': user_id,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      user_id: json['user_id'],
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({
    int? id,
    int? productId,
    String? name,
    String? image,
    double? price,
    int? quantity,
    int? user_id,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      user_id: quantity ?? this.user_id,
    );
  }
}
