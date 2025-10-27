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
      products: (json['products'] as List<dynamic>? ?? [])
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
   int? stock;
  final String? condition;
  final String? color;
  final String? size;
  final String? info1;
  final String? info2;
  final bool? isTopPick;
  final int? saveCount;
        int? likeCount;
  final int? viewCount;
  final String? sellerId;

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
    this.isTopPick,
    this.saveCount,
    this.likeCount,
    this.viewCount,
    this.sellerId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      category: json['category'] != null
          ? (json['category'] is Map
          ? Category.fromJson(json['category'])
          : null)
          : null,
      stock: json['stock'],
      condition: json['condition'],
      color: json['color'],
      size: json['size'],
      info1: json['info1'],
      info2: json['info2'],
      isTopPick: json['isTopPick'] ?? false,
      saveCount: json['saveCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      sellerId: json['sellerId'],
    );
  }

  /// Returns a list of available colors (for compatibility with UI)
  List<String> get availableColors {
    return color != null ? [color!] : ['Black', 'Grey', 'Blue'];
  }

  /// Returns a list of available sizes (for compatibility with UI)
  List<String> get availableSizes {
    return size != null ? [size!] : ['S', 'M', 'L', 'XL'];
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
