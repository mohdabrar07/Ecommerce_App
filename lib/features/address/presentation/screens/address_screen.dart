import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/address_cubit.dart';
import '../../logic/cubit/address_state.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {

          if (state is AddressLoaded) {

            if (state.addresses.isEmpty) {
              return const Center(child: Text("No Address Found"));
            }

            return ListView.builder(
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final a = state.addresses[index];

                return ListTile(
                  title: Text(a.fullName),
                  subtitle: Text("${a.area}, ${a.emirate}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<AddressCubit>().deleteAddress(a.id);
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}