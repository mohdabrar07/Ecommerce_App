import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';

// FIX: Points directly to your pre-existing core widgets repository folder
import '../../../../core/widgets/rating_bar_widget.dart'; 

import 'package:ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/features/cart/logic/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:ecommerce_app/features/wishlist/data/models/wishlist_item_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.images.first,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.product.description),
            const SizedBox(height: 10),
            Text(
              "AED ${widget.product.price}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, // FIX: Changed from invalid w640 to w600
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Chip(label: Text(widget.product.category.name)),
            const SizedBox(height: 20),
            Row(
              // FIX: Removed any strict 'const' keywords from this row's structure
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "$quantity",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartCubit>().addToCart(
                        CartItemModel(
                          id: widget.product.id,
                          title: widget.product.title,
                          image: widget.product.images.first,
                          price: widget.product.price.toDouble(),
                          quantity: quantity,
                        ),
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added $quantity item(s) to cart"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text("Add To Cart"),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Handled via WishlistCubit later
                },
                child: const Text("Add To Wishlist"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}