import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';

class OrderDetailsScreen
    extends StatelessWidget {

  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Order Details",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              "Order ID: ${order.orderId}",
            ),

            const SizedBox(height: 10),

            Text(
              "Date: ${order.date}",
            ),

            const SizedBox(height: 10),

            Text(
              "Payment: ${order.paymentMethod}",
            ),

            const SizedBox(height: 10),

            Text(
              "Amount: ₹${order.totalAmount}",
            ),

            const Divider(),

            const Text(
              "Order Timeline",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const ListTile(
              leading: Icon(
                Icons.check_circle,
              ),
              title: Text("PLACED"),
            ),

            const ListTile(
              leading: Icon(
                Icons.check_circle,
              ),
              title: Text(
                "CONFIRMED",
              ),
            ),

            const ListTile(
              leading: Icon(
                Icons.check_circle,
              ),
              title: Text("PACKED"),
            ),

            const ListTile(
              leading: Icon(
                Icons.local_shipping,
              ),
              title: Text(
                "OUT FOR DELIVERY",
              ),
            ),

            const ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: Text(
                "DELIVERED",
              ),
            ),
          ],
        ),
      ),
    );
  }
}