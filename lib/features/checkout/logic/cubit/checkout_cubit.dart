import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_state.dart';
import '../../../cart/data/models/cart_item_model.dart';

import 'package:ecommerce_app/features/address/data/models/address_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  void loadCheckout({
    required List<CartItemModel> cartItems,
    AddressModel? address,
  }) {
    emit(
      CheckoutLoaded(
        cartItems: cartItems,
        selectedAddress: address,
      ),
    );
  }

  void selectAddress(AddressModel address) {
    final current = state;
    if (current is CheckoutLoaded) {
      emit(
        CheckoutLoaded(
          cartItems: current.cartItems,
          selectedAddress: address,
        ),
      );
    }
  }
}
