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
        title: const Text("Addresses"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AddressCubit>().addAddress(
                AddressModel(
                  fullName: "Abrar",
                  mobileNumber: "9999999999", // FIX: Changed from mobile to mobileNumber
                  emirate: "Dubai",
                  area: "Al Nahda",
                  buildingName: "ABC",         // FIX: Changed from building to buildingName
                  flatNumber: "101",           // FIX: Changed from flat to flatNumber
                  landmark: "Near Mall",
                  isDefault: true,
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return const Center(
                child: Text("No Address Found"),
              );
            }

            return ListView.builder(
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];

                return ListTile(
                  leading: const Icon(Icons.home_work_outlined),
                  title: Text(address.fullName),
                  subtitle: Text(
                    "${address.buildingName}, ${address.area}, ${address.emirate}\nMob: ${address.mobileNumber}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () {
                      context.read<AddressCubit>().deleteAddress(index);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
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