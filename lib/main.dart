import 'package:ecommerce_app/core/widgets/splash_screen.dart';
import 'package:ecommerce_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  runApp(
    const MyApp(),
  );

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => AuthCubit(),

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        home: const SplashScreen(),

      ),

    );

  }

}