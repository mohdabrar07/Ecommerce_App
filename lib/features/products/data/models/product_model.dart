import 'category_model.dart'; // Ensure correct category file import path

class ProductModel {
  final int id;
  final String title;
  final num price;
  final String description;
  final List<String> images;
  final CategoryModel category;
  final ProductRating rating; // FIX: Added explicit type matching architecture standards

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    List<String> parseImages(dynamic imagesData) {
      if (imagesData is List) {
        return imagesData.map((e) => e.toString()).toList();
      } else if (imagesData is String) {
        return [imagesData];
      }
      return [];
    }

    // Extract raw category string data to generate an automated matching slug string if fallback hits
    final categoryName = json['categoryName'] as String? ?? 'General';
    final fallbackSlug = categoryName.toLowerCase().replaceAll(' ', '-');

    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      price: json['price'] as num? ?? 0.0,
      description: json['description'] as String? ?? '',
      images: parseImages(json['images'] ?? json['image']),
      category: json['category'] != null 
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : CategoryModel(
              id: 0, 
              name: categoryName, 
              image: '',
              slug: fallbackSlug, // FIX: Injected required named slug argument placeholder
            ),
      rating: ProductRating.fromJson(json['rating'] as Map<String, dynamic>?),
    );
  }
}

// FIX: Standalone structured validation class mapping
class ProductRating {
  final num rate;
  final int count;

  const ProductRating({
    required this.rate,
    required this.count,
  });

  factory ProductRating.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductRating(rate: 0.0, count: 0);
    }
    return ProductRating(
      rate: json['rate'] as num? ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }
}