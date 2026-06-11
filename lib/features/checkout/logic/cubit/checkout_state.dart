import 'package:equatable/equatable.dart';
import '../../../cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/features/address/data/models/address_model.dart';

abstract class CheckoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final List<CartItemModel> cartItems;
  final AddressModel? selectedAddress;

  CheckoutLoaded({
    required this.cartItems,
    this.selectedAddress,
  });

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  double get vat => subtotal * 0.05;

  double get total => subtotal + vat + 50;

  @override
  List<Object?> get props => [cartItems, selectedAddress];
}