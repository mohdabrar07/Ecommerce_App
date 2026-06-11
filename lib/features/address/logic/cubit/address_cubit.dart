import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/models/address_model.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {

  AddressCubit() : super(AddressInitial()) {
    loadAddresses();
  }

  final box = Hive.box('addressBox');

  void loadAddresses() {

    final addresses =
        box.values
            .map(
              (e) => AddressModel.fromMap(
                Map.from(e),
              ),
            )
            .toList();

    emit(
      AddressLoaded(addresses),
    );
  }

  void addAddress(
    AddressModel address,
  ) {

    box.add(
      address.toMap(),
    );

    loadAddresses();
  }

  void deleteAddress(
    int index,
  ) {

    box.deleteAt(index);

    loadAddresses();
  }
}