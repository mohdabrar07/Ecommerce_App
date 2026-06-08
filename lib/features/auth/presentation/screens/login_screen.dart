import 'package:ecommerce_app/features/products/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/auth_cubit.dart';
import '../../logic/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool obscurePassword = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => AuthCubit(),

      child: Scaffold(

        appBar: AppBar(
          title: const Text("Login"),
        ),

        body: BlocConsumer<AuthCubit, AuthState>(

          listener: (context, state) {

            if(state is AuthSuccess) {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HomeScreen(),
                ),
              );

            }

            if(state is AuthError) {

              ScaffoldMessenger.of(context)
                  .showSnackBar(

                SnackBar(
                  content: Text(state.message),
                ),

              );

            }

          },

          builder: (context, state) {

            return Padding(

              padding: const EdgeInsets.all(16),

              child: Form(

                key: formKey,

                child: Column(

                  children: [

                    TextFormField(

                      controller: emailController,

                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),

                      validator: (value) {

                        if(value == null ||
                            value.isEmpty) {

                          return "Enter email";

                        }

                        return null;

                      },

                    ),

                    const SizedBox(height: 20),

                    TextFormField(

                      controller:
                          passwordController,

                      obscureText:
                          obscurePassword,

                      decoration: InputDecoration(

                        labelText: "Password",

                        suffixIcon: IconButton(

                          onPressed: () {

                            setState(() {

                              obscurePassword =
                                  !obscurePassword;

                            });

                          },

                          icon: Icon(

                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,

                          ),

                        ),

                      ),

                      validator: (value) {

                        if(value == null ||
                            value.isEmpty) {

                          return
                              "Enter password";

                        }

                        return null;

                      },

                    ),

                    const SizedBox(height: 30),

                    state is AuthLoading

                        ? const CircularProgressIndicator()

                        : ElevatedButton(

                            onPressed: () {

                              if(formKey
                                  .currentState!
                                  .validate()) {

                                context
                                    .read<AuthCubit>()
                                    .login(

                                  email:
                                      emailController.text,

                                  password:
                                      passwordController.text,

                                );

                              }

                            },

                            child:
                                const Text("Login"),

                          ),

                  ],

                ),

              ),

            );

          },

        ),

      ),

    );

  }

}