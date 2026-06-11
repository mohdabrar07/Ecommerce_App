class CartItemModel {
  final int id;
  final String title;
  final String image;
  final double price;
  int quantity; // Kept as mutable variable if your existing code relies on direct tracking

  CartItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  // Calculate total price for individual list item lines
  double get totalPrice => price * quantity;

  // FIX: Added copyWith method to handle immutable state emissions cleanly
  CartItemModel copyWith({
    int? id,
    String? title,
    String? image,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  // Map serialization tools for Hive local storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<dynamic, dynamic> map) {
    return CartItemModel(
      id: map['id'] as int,
      title: map['title'] as String,
      image: map['image'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}