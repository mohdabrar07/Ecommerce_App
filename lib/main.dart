import 'package:ecommerce_app/core/widgets/splash_screen.dart';
import 'package:ecommerce_app/features/cart/logic/cubit/cart_cubit.dart';
import 'package:ecommerce_app/features/products/logic/cubit/product_cubit.dart';
import 'package:ecommerce_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ecommerce_app/features/wishlist/logic/cubit/wishlist_cubit.dart';
import 'features/address/logic/cubit/address_cubit.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
 await Hive.openBox('appBox');
  await Hive.openBox('cartBox');
  await Hive.openBox('addressBox');
  await Hive.openBox('wishlistBox');
  runApp(
    const MyApp(),
  );

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

   return MultiBlocProvider(

  providers: [

    BlocProvider(
      create: (_) => AuthCubit(),
    ),
  
    BlocProvider(
      create: (_) => ProductCubit(),
    ),
  BlocProvider(
  create: (_) => CartCubit(),
),
BlocProvider(
  create: (_) => WishlistCubit(),
),
BlocProvider(
  create: (_) => AddressCubit(),
),
  ],

  child: MaterialApp(

    debugShowCheckedModeBanner:
        false,

    home: const SplashScreen(),

  ),

);

  }

}