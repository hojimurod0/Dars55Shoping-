import 'dart:convert';
import 'package:dars_55/models/product.dart';
import 'package:http/http.dart' as http;

class ProductHttpService {
  static const String url =
      'https://dars46-43428-default-rtdb.firebaseio.com/praducts.json';

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> data = json.decode(response.body);
    final List<Product> loadedProducts = [];

    data.forEach((productId, productData) {
      loadedProducts.add(Product(
        id: productId,
        title: productData['title'],
        image: productData['image'],
        price: productData['price'].toDouble(),
        amount: productData['amount'],
      ));
    });
    return loadedProducts;
  }
}
