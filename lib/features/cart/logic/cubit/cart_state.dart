import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

// FIX: Added the missing CartEmpty state required by Rule 3
class CartEmpty extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;

  const CartLoaded(this.items);

  // Mathematics for the required price summaries
  double get subtotal => items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  
  double get vat => subtotal * 0.05; // 5% VAT requirement
  
  double get deliveryCharge => subtotal > 200 ? 0.0 : 15.0; // Dynamic delivery logic
  
  double get total => subtotal + vat + deliveryCharge;

  @override
  List<Object?> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}