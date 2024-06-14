import 'package:dars_55/models/product.dart';
import 'package:dars_55/services/product_http_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  Map<String, int> _cart = {};
  double _totalPrice = 0.0;
  final ProductHttpService _productHttpService = ProductHttpService();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await _productHttpService.fetchProducts();
    setState(() {
      _products = products;
    });
  }

  void _addToCart(String productId, int quantity) {
    setState(() {
      _cart[productId] = (_cart[productId] ?? 0) + quantity;
      _totalPrice +=
          _products.firstWhere((prod) => prod.id == productId).price * quantity;
    });
  }

  double _calculateTotalCartValue() {
    double total = 0.0;
    _cart.forEach((productId, quantity) {
      final product = _products.firstWhere((prod) => prod.id == productId);
      total += product.price * quantity;
    });
    return total;
  }

  void _showAddToCartDialog(Product product) {
    final quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add ${product.title} to cart'),
          content: TextField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'necha dona olasiz'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final quantity = int.tryParse(quantityController.text);
                if (quantity != null && quantity > 0) {
                  _addToCart(product.id, quantity);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: _cart.entries.map((entry) {
                  final product =
                      _products.firstWhere((prod) => prod.id == entry.key);
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text('${entry.value}'),
                    trailing: Text(
                        '\$${(product.price * entry.value).toStringAsFixed(2)}'),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Jami: \$${_calculateTotalCartValue().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.book_outlined,
              size: 50,
              color: Color.fromARGB(255, 129, 14, 5),
            ),
            Text(
              "Shopping",
              style: TextStyle(
                fontSize: 50,
                color: Color.fromARGB(255, 129, 14, 5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove("userData");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 2 / 3,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, i) {
          final product = _products[i];
          return GridTile(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[200]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          "Narxi:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(" \$${product.price.toStringAsFixed(2)}"),
                      ],
                    ),
                    Text(
                      "${product.amount.toStringAsFixed(2)} ta sotib olganlar",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () => _showAddToCartDialog(product),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.shopping_cart),
        onPressed: _showCart,
      ),
    );
  }
}
