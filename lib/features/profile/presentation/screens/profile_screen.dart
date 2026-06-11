import 'package:flutter/material.dart';
// FIX: Navigates straight to your verified checkout engine containing full address management features
import 'package:ecommerce_app/features/checkout/presentation/screens/checkout_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // USER AVATAR DISPLAY
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Text(
                      "JD",
                      style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "John Doe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "john.doe@example.com",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "+971 50 123 4567",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // NAVIGATION LIST SET
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: Colors.blue),
                      title: const Text("Manage Shipping Addresses"),
                      subtitle: const Text("Add, edit, or select delivery choices"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(), 
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // FIX: Repaired OutlinedButton.styleFrom arguments parameters layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48), // Correct syntax for size initialization
                  side: const BorderSide(color: Colors.redAccent),
                  foregroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout & Clear Session"),
              ),
            )
          ],
        ),
      ),
    );
  }
}