import 'package:equatable/equatable.dart';
import '../../../address/data/models/address_model.dart';
import '../../../cart/data/models/cart_item_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final List<CartItemModel> cartItems;
  final AddressModel? selectedAddress;

  const CheckoutLoaded({
    required this.cartItems,
    this.selectedAddress,
  });

  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double get vat => subtotal * 0.05;
  double get deliveryCharge => subtotal > 200 ? 0.0 : 15.0;
  double get total => subtotal + vat + deliveryCharge;

  @override
  List<Object?> get props => [cartItems, selectedAddress];
}

// FIX: Added the missing CheckoutSuccess state with fields expected by the UI
class CheckoutSuccess extends CheckoutState {
  final String orderId;
  final double totalAmount;
  final String paymentMethod;

  const CheckoutSuccess({
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [orderId, totalAmount, paymentMethod];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}