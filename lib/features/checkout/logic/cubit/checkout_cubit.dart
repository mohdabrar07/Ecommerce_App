import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkout_state.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../address/data/models/address_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  // 1. Initial State Hydration Loader
  void loadCheckout({required List<CartItemModel> cartItems, AddressModel? address}) {
    emit(CheckoutLoading());
    try {
      if (cartItems.isEmpty) {
        emit(const CheckoutError("Cannot proceed to checkout with an empty cart"));
        return;
      }
      
      emit(CheckoutLoaded(
        cartItems: cartItems,
        selectedAddress: address,
      ));
    } catch (e) {
      emit(CheckoutError("Failed to initialize checkout breakdown: ${e.toString()}"));
    }
  }

  // 2. FIX: Added the missing clean placeOrder business logic method
  void placeOrder({
    required AddressModel address,
    required String paymentMethod,
    required double totalAmount,
  }) {
    // Cache current state items to ensure safe operation processing
    final currentState = state;
    if (currentState is CheckoutLoaded) {
      emit(CheckoutLoading());
      try {
        // Generate a random unique mock Order ID as required for the Success Screen
        final randomNum = Random().nextInt(900000) + 100000;
        final generatedOrderId = "ORD$randomNum";

        // Dispatch business logic success signature event to the UI layer listener
        emit(CheckoutSuccess(
          orderId: generatedOrderId,
          totalAmount: totalAmount,
          paymentMethod: paymentMethod,
        ));
      } catch (e) {
        emit(CheckoutError("Order processing failed: ${e.toString()}"));
      }
    } else {
      emit(const CheckoutError("Invalid checkout state session context. Please try again."));
    }
  }
}