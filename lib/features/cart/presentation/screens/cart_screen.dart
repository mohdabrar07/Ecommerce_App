import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/cart_cubit.dart';
import '../../logic/cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {

          if (state is CartLoaded) {

  if (state.items.isEmpty) {
    return const Center(
      child: Text(
        "No cart items found",
      ),
    );
  }

  return Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];

                      return ListTile(
  leading: Image.network(
    item.image,
    width: 50,
    height: 50,
  ),

  title: Text(item.title),

  subtitle: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [

      Text("₹${item.price}"),

      Text(
        "Total: ₹${item.totalPrice}",
      ),

    ],
  ),

  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [

      IconButton(
        onPressed: () =>
            context.read<CartCubit>()
                .decrease(item.id),
        icon: const Icon(Icons.remove),
      ),

      Text("${item.quantity}"),

      IconButton(
        onPressed: () =>
            context.read<CartCubit>()
                .increase(item.id),
        icon: const Icon(Icons.add),
      ),

      IconButton(
        onPressed: () =>
            context.read<CartCubit>()
                .remove(item.id),
        icon: const Icon(
          Icons.delete,
        ),
      ),

    ],
  ),
);
                    },
                  ),
                ),

               Padding(
  padding: const EdgeInsets.all(16),

  child: Column(

    children: [

      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text("Subtotal"),
          Text("₹${state.subtotal}"),
        ],
      ),

      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text("VAT (5%)"),
          Text("₹${state.vat}"),
        ],
      ),

      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: const [
          Text("Delivery"),
          Text("₹50"),
        ],
      ),

      const Divider(),

      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Grand Total",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          Text(
            "₹${state.total}",
          ),
        ],
      ),

      const SizedBox(height: 20),

      SizedBox(
        width: double.infinity,

        child: ElevatedButton(

          onPressed: () {

          },

          child: const Text(
            "Proceed To Checkout",
          ),

        ),
      ),

    ],

  ),

),

                const SizedBox(height: 10),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}