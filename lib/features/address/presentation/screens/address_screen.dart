import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/address_model.dart';
import '../../logic/cubit/address_cubit.dart';
import '../../logic/cubit/address_state.dart';

class AddressScreen extends StatelessWidget {

  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Addresses",
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: () {

          context
              .read<AddressCubit>()
              .addAddress(

                AddressModel(
                  fullName: "Abrar",
                  mobile: "9999999999",
                  emirate: "Dubai",
                  area: "Al Nahda",
                  building: "ABC",
                  flat: "101",
                  landmark: "Near Mall",
                ),

              );

        },

        child: const Icon(
          Icons.add,
        ),
      ),

      body: BlocBuilder<
          AddressCubit,
          AddressState>(
        builder: (context, state) {

          if (state is AddressLoaded) {

            if (state.addresses.isEmpty) {

              return const Center(
                child: Text(
                  "No Address Found",
                ),
              );

            }

            return ListView.builder(

              itemCount:
                  state.addresses.length,

              itemBuilder:
                  (context,index) {

                final address =
                    state.addresses[index];

                return ListTile(

                  title: Text(
                    address.fullName,
                  ),

                  subtitle: Text(
                    address.area,
                  ),

                  trailing: IconButton(

                    onPressed: () {

                      context
                          .read<
                              AddressCubit>()
                          .deleteAddress(
                              index);

                    },

                    icon: const Icon(
                      Icons.delete,
                    ),

                  ),

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