class CategoriesResponse {
  final bool success;
  final String message;
  final List<Category> categories;

  CategoriesResponse({
    required this.success,
    required this.message,
    required this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'categories': categories.map((e) => e.toJson()).toList(),
  };
}

class Category {
  final String id;
  final String name;
  final String? easyname; 
  final String? description;
  final String? iconUrl;
  final String? bannerImageUrl;
  final int? sortOrder;
  final bool? isActive;
  final bool? showOnHomeChip;
  final int? priority;
  final String? createdAt;
  final String? updatedAt;
  final CategoryImage? image;
  final String? slug;
  final List<SubCategory>? subCategories;

  Category({
    required this.id,
    required this.name,
    this.easyname,
    this.description,
    this.iconUrl,
    this.bannerImageUrl,
    this.sortOrder,
    this.isActive,
    this.showOnHomeChip,
    this.priority,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.slug,
    required List<SubCategory> subCategories,
  }) : this.subCategories = subCategories.isEmpty
      ? [
    SubCategory(
      id: 'dummy-id-$id',
      name: 'No Sub-category',
      slug: 'no-subcategory',
      createdAt: DateTime.now().toIso8601String(),
    )
  ]
      : subCategories;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      easyname: json['easyname'], // Nullable now
      description: json['description'],
      iconUrl: json['iconUrl'],
      bannerImageUrl: json['bannerImageUrl'],
      sortOrder: json['sortOrder'] != null
          ? int.tryParse(json['sortOrder'].toString())
          : null,
      isActive: json['isActive'],
      showOnHomeChip: json['showOnHomeChip'],
      priority: json['priority'] != null
          ? int.tryParse(json['priority'].toString())
          : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      image:
      json['image'] != null ? CategoryImage.fromJson(json['image']) : null,
      slug: json['slug'],
      subCategories: (json['subCategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'easyname': easyname,
    'description': description,
    'iconUrl': iconUrl,
    'bannerImageUrl': bannerImageUrl,
    'sortOrder': sortOrder,
    'isActive': isActive,
    'showOnHomeChip': showOnHomeChip,
    'priority': priority,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'image': image?.toJson(),
    'slug': slug,
    'subCategories': subCategories
        ?.where((sub) => !sub.id.startsWith('dummy-id'))
        .map((e) => e.toJson())
        .toList(),
  };
}

class SubCategory {
  final String id;
  final String name;
  final String slug;
  final String createdAt;
  final CategoryImage? image;

  SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      createdAt: json['createdAt'] ?? '',
      image:
      json['image'] != null ? CategoryImage.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'slug': slug,
    'createdAt': createdAt,
    'image': image?.toJson(),
  };
}

class CategoryImage {
  final String publicId;
  final String url;

  CategoryImage({required this.publicId, required this.url});

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'public_id': publicId,
    'url': url,
  };
}
