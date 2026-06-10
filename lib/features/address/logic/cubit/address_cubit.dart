import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/models/address_model.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

  final box = Hive.box('addressBox');

  void loadAddresses() {
    final data = box.values.toList();
    final addresses =
        data.map((e) => AddressModel.fromMap(Map.from(e))).toList();

    emit(AddressLoaded(addresses));
  }

  void addAddress(AddressModel address) {
    final current = box.values.toList();
    current.add(address.toMap());

    box.clear();
    box.addAll(current);

    loadAddresses();
  }

  void deleteAddress(String id) {
    final current = box.values.toList();

    current.removeWhere((e) => e["id"] == id);

    box.clear();
    box.addAll(current);

    loadAddresses();
  }

  void setDefault(String id) {
    final current = box.values.toList();

    for (var item in current) {
      item["isDefault"] = item["id"] == id;
    }

    box.clear();
    box.addAll(current);

    loadAddresses();
  }
}