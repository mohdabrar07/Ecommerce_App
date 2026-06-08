import 'package:ecommerce_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/logic/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();

}

class _HomeScreenState
    extends State<HomeScreen> {

  @override
  void initState() {

    super.initState();

    context.read<AuthCubit>()
        .getProfile();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Home"),
      ),

      body: BlocBuilder<AuthCubit, AuthState>(

        builder: (context, state) {

          if(state is AuthLoading) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );

          }

          if(state is ProfileLoaded) {

            final user = state.user;

            return Center(

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  CircleAvatar(

                    radius: 40,

                    backgroundImage:
                        NetworkImage(
                      user.avatar,
                    ),

                  ),

                  const SizedBox(height: 20),

                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),

                  Text(user.email),

                  Text(user.role),

                ],

              ),

            );

          }

          if(state is AuthError) {

            return Center(
              child: Text(state.message),
            );

          }

          return const SizedBox();

        },

      ),

    );

  }

}