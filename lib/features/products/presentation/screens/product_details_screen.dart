import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/features/cart/logic/cubit/cart_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
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

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Image.network(
              widget.product.images.first,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
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
            Text(
              widget.product.description,
            ),

            const SizedBox(height: 10),
            Text(
              "AED ${widget.product.price}",
            ),

            const SizedBox(height: 10),

            Text(
              widget.product.category.name,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if(quantity > 1){
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),

                Text("$quantity"),

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
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Added to cart"),
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

                onPressed: () {},

                child: const Text(
                  "Add To Wishlist",
                ),

              ),

            ),

          ],

        ),

      ),

    );

  }
}