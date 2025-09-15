import 'package:zatch_app/model/categories_response.dart';

class ProductResponse {
  final bool success;
  final String message;
  final List<Product> products;

  ProductResponse({
    required this.success,
    required this.message,
    required this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<ProductImage> images;
  final Category? category;
  final int? stock;
  final String? condition;
  final String? color;
  final String? size;
  final String? info1;
  final String? info2;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    this.category,
    this.stock,
    this.condition,
    this.color,
    this.size,
    this.info1,
    this.info2,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      stock: json['stock'],
      condition: json['condition'],
      color: json['color'],
      size: json['size'],
      info1: json['info1'],
      info2: json['info2'],
    );
  }
}

class ProductImage {
  final String publicId;
  final String url;
  final String id;

  ProductImage({
    required this.publicId,
    required this.url,
    required this.id,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}

/*class Category {
  final String id;
  final String name;
  final String slug;
  final CategoryImage image;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: CategoryImage.fromJson(json['image']),
    );
  }
}

class CategoryImage {
  final String publicId;
  final String url;

  CategoryImage({
    required this.publicId,
    required this.url,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }
}*/
