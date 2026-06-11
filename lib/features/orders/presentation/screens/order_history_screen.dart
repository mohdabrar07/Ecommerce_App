import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_details_screen.dart';
import '../../logic/cubit/order_cubit.dart';
import '../../logic/cubit/order_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: BlocBuilder<
          OrderCubit,
          OrderState>(
        builder: (context, state) {
          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(
                child: Text(
                  "No order history found",
                ),
              );
            }

            return ListView.builder(
              itemCount:
                  state.orders.length,
              itemBuilder:
                  (context, index) {
                final order =
                    state.orders[index];

                return ListTile(
  title: Text(order.orderId),

  subtitle: Text(order.date),

  trailing: Text(
    "₹${order.totalAmount}",
  ),

  onTap: () {

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (_) =>
            OrderDetailsScreen(
              order: order,
            ),
      ),
    );

  },
);
              },
            );
          }

          return const Center(
            child:
                CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}