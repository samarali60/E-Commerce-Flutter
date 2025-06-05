class Product {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final int discount;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.discount,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discount: json['discount'],
      image: json['image'],
    );
  }
}
