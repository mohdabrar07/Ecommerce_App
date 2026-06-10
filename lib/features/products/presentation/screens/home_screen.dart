import 'package:ecommerce_app/features/products/logic/cubit/product_cubit.dart';
import 'package:ecommerce_app/features/products/logic/cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_details_screen.dart';
import 'package:ecommerce_app/features/cart/presentation/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();

}

class _HomeScreenState
    extends State<HomeScreen> {

  @override
  void initState() {

    super.initState();

    context
        .read<ProductCubit>()
        .getProducts();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
  title: const Text("Products"),

  actions: [

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

  ],
),

      body: BlocBuilder<
          ProductCubit,
          ProductState>(

        builder: (context, state) {

          if(state
              is ProductLoading) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );

          }

          if(state
              is ProductError) {

            return Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Text(state.message),

                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(

                    onPressed: () {

                      context
                          .read<
                              ProductCubit>()
                          .getProducts();

                    },

                    child: const Text(
                      "Retry",
                    ),

                  ),

                ],

              ),

            );

          }

          if(state
              is ProductLoaded) {

            final products =
                state.products;

            return GridView.builder(

              padding:
                  const EdgeInsets.all(10),

              itemCount:
                  products.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount: 2,

                crossAxisSpacing: 10,

                mainAxisSpacing: 10,

                childAspectRatio: 0.65,

              ),

              itemBuilder:
                  (context, index) {

                final product =
                    products[index];

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

    child: Padding(

      padding: const EdgeInsets.all(10),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Expanded(

            child: Image.network(

              product.images[0],

              fit: BoxFit.cover,

              width: double.infinity,

            ),

          ),

          const SizedBox(height: 10),

          Text(

            product.title,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

          ),

          const SizedBox(height: 5),

          Text(
            "\$${product.price}",
          ),

          Text(
            product.category.name,
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