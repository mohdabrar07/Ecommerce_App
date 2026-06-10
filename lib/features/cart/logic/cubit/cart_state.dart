import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;

  CartLoaded(this.items);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  double get vat => subtotal * 0.05;

  double get total => subtotal + vat + 50; // delivery charge

  @override
  List<Object?> get props => [items];
}