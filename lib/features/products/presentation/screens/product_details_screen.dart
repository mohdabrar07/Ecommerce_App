import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
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
            // IMAGE DISPLAY CONTAINER
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.product.images.isNotEmpty
                  ? Image.network(
                      widget.product.images.first,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          ),
                        );
                      },
                    )
                  : const Center(child: Icon(Icons.image_not_supported, size: 50)),
            ),
            const SizedBox(height: 20),
            
            // PRODUCT TITLE
            Text(
              widget.product.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // INLINE RATING DISPLAY
            RatingBarWidget(
              rate: widget.product.rating.rate.toDouble(),
              count: widget.product.rating.count,
            ),
            const SizedBox(height: 15),

            // DESCRIPTION LINE TEXT TRACK
            Text(
              widget.product.description,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 15),

            // PRICE ELEMENT
            Text(
              "AED ${widget.product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            // CATEGORY CHIP TAG
            Chip(
              label: Text(widget.product.category.name),
              backgroundColor: Colors.blue.shade50,
              labelStyle: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // QUANTITY INC / DEC BUTTONS
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ADD TO CART ACTION BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartCubit>().addToCart(
                        CartItemModel(
                          id: widget.product.id,
                          title: widget.product.title,
                          image: widget.product.images.isNotEmpty ? widget.product.images.first : '',
                          price: widget.product.price.toDouble(),
                          quantity: quantity,
                        ),
                      );

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Added $quantity item(s) to cart successfully!"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text("Add To Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),

            // IMPLEMENTED REAL ACTION HANDLER FOR WISHLIST CUBIT MAPPING
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  context.read<WishlistCubit>().toggleWishlist(
                        WishlistItemModel(
                          id: widget.product.id,
                          title: widget.product.title,
                          image: widget.product.images.isNotEmpty ? widget.product.images.first : '',
                          price: widget.product.price.toDouble(),
                        ),
                      );

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${widget.product.title} updated in wishlist"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text("Add To Wishlist", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MERGED LOCAL RATINGS COMPONENT ---
class RatingBarWidget extends StatelessWidget {
  final double rate;
  final int count;

  const RatingBarWidget({
    super.key,
    required this.rate,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rate.floor();
    bool hasHalfStar = (rate - fullStars) >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(5, (index) {
            if (index < fullStars) {
              return const Icon(Icons.star, color: Colors.amber, size: 18);
            } else if (index == fullStars && hasHalfStar) {
              return const Icon(Icons.star_half, color: Colors.amber, size: 18);
            } else {
              return const Icon(Icons.star_border, color: Colors.amber, size: 18);
            }
          }),
        ),
        const SizedBox(width: 6),
        Text(
          "${rate.toStringAsFixed(1)} ($count reviews)",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}