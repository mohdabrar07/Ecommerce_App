import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// FEATURES CORE LOGGER & SCHEMES
import 'package:ecommerce_app/features/home/presentation/screens/main_navigation_shell.dart';
import 'package:ecommerce_app/features/products/logic/cubit/product_cubit.dart';
import 'package:ecommerce_app/features/cart/logic/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/wishlist/logic/cubit/wishlist_cubit.dart';

// NOTE: Add any other global Cubit/Bloc dependencies your app relies on here

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Rule 1 & Rule 3 Verification: Providers must wrap the root MaterialApp element
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<WishlistCubit>(
          create: (context) => WishlistCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        // Landing layout defaults right onto the bottom navigation switcher pipeline
        home: const MainNavigationShell(), 
      ),
    );
  }
}