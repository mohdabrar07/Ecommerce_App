import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/logic/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/checkout/logic/cubit/checkout_cubit.dart';
import 'package:ecommerce_app/features/checkout/logic/cubit/checkout_state.dart';
import 'package:ecommerce_app/features/cart/logic/cubit/cart_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentMethod = "COD";

  @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final cartState = context.read<CartCubit>().state;

    if (cartState is CartLoaded) {
      context.read<CheckoutCubit>().loadCheckout(
            cartItems: cartState.items,
          );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {

          if (state is CheckoutLoaded) {

            return Column(
              children: [

                // ADDRESS SECTION
                ListTile(
                  title: const Text("Delivery Address"),
                  subtitle: Text(
                    state.selectedAddress?.fullName ??
                        "No address selected",
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text("Change"),
                  ),
                ),

                const Divider(),

                // PAYMENT
                RadioListTile(
                  value: "COD",
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                    });
                  },
                  title: const Text("Cash on Delivery"),
                ),

                RadioListTile(
                  value: "CARD",
                  groupValue: paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value!;
                    });
                  },
                  title: const Text("Card"),
                ),

                const Divider(),

                // SUMMARY
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total"),
                          Text("₹${state.total}"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Place Order"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}