import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/logic/cubit/cart_cubit.dart';
import '../../../cart/logic/cubit/cart_state.dart';
import '../../logic/cubit/checkout_cubit.dart';
import '../../logic/cubit/checkout_state.dart';
import '../../../address/presentation/screens/address_screen.dart';
import '../../../orders/presentation/screens/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentMethod = "Cash on Delivery"; 

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
      body: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            // Reload clean cart state once local database operation saves
            context.read<CartCubit>().loadCart();
            
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OrderSuccessScreen(
                  orderId: state.orderId,
                  amount: state.totalAmount, // FIX: Adjusted to your explicit parameter name
                  paymentMethod: state.paymentMethod,
                ),
              ),
              (route) => route.isFirst,
            );
          } else if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CheckoutLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ADDRESS SECTION
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.blue),
                      title: const Text(
                        "Delivery Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        state.selectedAddress != null
                            ? "${state.selectedAddress!.fullName}\n${state.selectedAddress!.buildingName}, ${state.selectedAddress!.area}\n${state.selectedAddress!.emirate}\nMob: ${state.selectedAddress!.mobileNumber}"
                            : "No address selected",
                      ),
                      isThreeLine: state.selectedAddress != null,
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressScreen(),
                            ),
                          ).then((_) {
                            final cartState = context.read<CartCubit>().state;
                            if (cartState is CartLoaded) {
                              context.read<CheckoutCubit>().loadCheckout(
                                    cartItems: cartState.items,
                                  );
                            }
                          });
                        },
                        child: const Text("Change"),
                      ),
                    ),
                    const Divider(),

                    // PAYMENT METHOD SECTION
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Payment Method",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RadioListTile<String>(
                      value: "Cash on Delivery",
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      title: const Text("Cash on Delivery (COD)"),
                    ),
                    RadioListTile<String>(
                      value: "Card Payment",
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      title: const Text("Card Payment"),
                    ),
                    RadioListTile<String>(
                      value: "Wallet",
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      title: const Text("Wallet"),
                    ),
                    const Divider(),

                    // FINAL AMOUNT SUMMARY
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Final Amount",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "AED ${state.total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (state.selectedAddress == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select a valid delivery address first"),
                                    ),
                                  );
                                  return;
                                }
                                
                                context.read<CheckoutCubit>().placeOrder(
                                      address: state.selectedAddress!,
                                      paymentMethod: paymentMethod,
                                      totalAmount: state.total,
                                    );
                              },
                              child: const Text(
                                "Place Order",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is CheckoutError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final cartState = context.read<CartCubit>().state;
                        if (cartState is CartLoaded) {
                          context.read<CheckoutCubit>().loadCheckout(cartItems: cartState.items);
                        }
                      },
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }

            return const Center(child: Text("No checkout information initialized."));
          },
        ),
      ),
    );
  }
}