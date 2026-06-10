import 'package:ecommerce_app/features/products/logic/cubit/product_cubit.dart';
import 'package:ecommerce_app/features/products/logic/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_details_screen.dart';
import 'package:ecommerce_app/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:ecommerce_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:ecommerce_app/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:ecommerce_app/features/wishlist/data/models/wishlist_item_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products when screen loads
    context.read<ProductCubit>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          // 🛒 CART BUTTON
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartScreen(),
                ),
              );
            },
          ),
          // ❤️ WISHLIST NAVIGATION BUTTON (Fixed Scope Error)
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WishlistScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductCubit>().getProducts();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            final products = state.products;

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6, // Adjusted slightly to prevent card overflow
              ),
              itemBuilder: (context, index) {
                final product = products[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias, // Keeps image corners rounded matching the card
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image Safely Loaded
                          Expanded(
                            child: product.images.isNotEmpty
                                ? Image.network(
                                    product.images.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : const Center(child: Icon(Icons.image_not_supported)),
                          ),
                          const SizedBox(height: 10),
                          // Title
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          // Price & Category Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\$${product.price}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.category.name,
                                    style: TextStyle(
                                      color: Colors.grey[640],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              // Card Wishlist Toggle Button
                              IconButton(
                                icon: const Icon(Icons.favorite_border), // Pro Tip: Wrap this item icon inside a BlocBuilder of WishlistCubit to dynamically switch to Icons.favorite if item is already in wishlist!
                                onPressed: () {
                                  context.read<WishlistCubit>().toggleWishlist(
                                        WishlistItemModel(
                                          id: product.id,
                                          title: product.title,
                                          image: product.images.isNotEmpty ? product.images.first : '',
                                          price: product.price.toDouble(),
                                        ),
                                      );

                                  ScaffoldMessenger.of(context).clearSnackBars(); // Prevents multiple rapid clicks stacking bars
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${product.title} updated in wishlist"),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}