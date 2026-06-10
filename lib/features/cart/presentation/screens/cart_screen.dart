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
              return const Center(child: Text("Cart is empty"));
            }

            return Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];

                      return ListTile(
                        leading: Image.network(item.image),
                        title: Text(item.title),
                        subtitle: Text("₹${item.price}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.read<CartCubit>().decrease(item.id),
                              icon: const Icon(Icons.remove),
                            ),
                            Text("${item.quantity}"),
                            IconButton(
                              onPressed: () =>
                                  context.read<CartCubit>().increase(item.id),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Text("Subtotal: ${state.subtotal}"),
                Text("VAT (5%): ${state.vat}"),
                Text("Total: ${state.total}"),

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