import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/wishlist_cubit.dart';
import '../../logic/cubit/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),

      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {

          if (state is WishlistLoaded) {

            if (state.items.isEmpty) {
              return const Center(
                child: Text("Wishlist is empty"),
              );
            }

            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {

                final item = state.items[index];

                return ListTile(
                  leading: Image.network(item.image),
                  title: Text(item.title),
                  subtitle: Text("₹${item.price}"),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}