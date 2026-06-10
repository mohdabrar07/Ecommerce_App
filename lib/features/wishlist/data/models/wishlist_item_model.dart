class WishlistItemModel {
  final int id;
  final String title;
  final String image;
  final double price;

  WishlistItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "image": image,
      "price": price,
    };
  }

  factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
    return WishlistItemModel(
      id: map["id"],
      title: map["title"],
      image: map["image"],
      price: map["price"],
    );
  }
}