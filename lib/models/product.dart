class Product {
  final String id;
  final String title;
  final String image;
  final double price;
  final int amount;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: json['price'].toDouble(),
      amount: json['amount'],
    );
  }
}
