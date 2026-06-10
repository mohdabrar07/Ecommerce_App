class CartItemModel {
  final int id;
  final String title;
  final String image;
  final double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "image": image,
      "price": price,
      "quantity": quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map["id"],
      title: map["title"],
      image: map["image"],
      price: map["price"],
      quantity: map["quantity"],
    );
  }
}