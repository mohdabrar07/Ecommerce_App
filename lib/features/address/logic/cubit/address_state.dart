import 'package:equatable/equatable.dart';
import '../../data/models/address_model.dart';

abstract class AddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;

  AddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}