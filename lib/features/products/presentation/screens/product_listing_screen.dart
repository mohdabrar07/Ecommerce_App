import 'package:ecommerce_app/features/products/logic/cubit/product_cubit.dart';
import 'package:ecommerce_app/features/products/logic/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_details_screen.dart';
import 'package:ecommerce_app/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'package:ecommerce_app/features/wishlist/data/models/wishlist_item_model.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'None'; // Options: 'None', 'LowToHigh', 'HighToLow'

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Products"),
        actions: [
          // PRICE SORTING POPUP MENU
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: "Sort by Price",
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'None', child: Text("Default Sort")),
              const PopupMenuItem(value: 'LowToHigh', child: Text("Price: Low to High")),
              const PopupMenuItem(value: 'HighToLow', child: Text("Price: High to Low")),
            ],
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProductCubit>().getProducts(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            final categories = ['All', ...state.products.map((p) => p.category.name).toSet()];

            // Apply Search & Category Filters
            var filteredProducts = state.products.where((product) {
              final matchesSearch = product.title.toLowerCase().contains(_searchController.text.toLowerCase());
              final matchesCategory = _selectedCategory == 'All' || product.category.name == _selectedCategory;
              return matchesSearch && matchesCategory;
            }).toList();

            // PRICE SORTING ENGINE
            if (_sortBy == 'LowToHigh') {
              filteredProducts.sort((a, b) => a.price.compareTo(b.price));
            } else if (_sortBy == 'HighToLow') {
              filteredProducts.sort((a, b) => b.price.compareTo(a.price));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductCubit>().getProducts();
              },
              child: Column(
                children: [
                  // SEARCH BAR
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  // CATEGORY FILTER HORIZONTAL LIST
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // PRODUCT GRID
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? const Center(child: Text("No products match filters."))
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                                  );
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8),
                                          child: Image.network(product.images.first, fit: BoxFit.contain),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(product.category.name, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                                            const SizedBox(height: 4),
                                            Text("AED ${product.price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            // INLINE LOCAL RATING COMPONENT CALL
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                RatingBarWidget(
                                                  rate: product.rating.rate.toDouble(),
                                                  count: product.rating.count,
                                                ),
                                                IconButton(
                                                  constraints: const BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                  icon: const Icon(Icons.favorite_border, size: 18),
                                                  onPressed: () {
                                                    context.read<WishlistCubit>().toggleWishlist(
                                                          WishlistItemModel(
                                                            id: product.id,
                                                            title: product.title,
                                                            image: product.images.first,
                                                            price: product.price.toDouble(),
                                                          ),
                                                        );
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
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
              return const Icon(Icons.star, color: Colors.amber, size: 14);
            } else if (index == fullStars && hasHalfStar) {
              return const Icon(Icons.star_half, color: Colors.amber, size: 14);
            } else {
              return const Icon(Icons.star_border, color: Colors.amber, size: 14);
            }
          }),
        ),
        const SizedBox(width: 4),
        Text(
          "${rate.toStringAsFixed(1)}",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}