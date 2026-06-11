import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/models/order_model.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial()) {
    loadOrders();
  }

  final box = Hive.box('ordersBox');

  void loadOrders() {
    final orders = box.values
        .map(
          (e) => OrderModel.fromMap(
            Map.from(e),
          ),
        )
        .toList();

    emit(OrderLoaded(orders));
  }

  void placeOrder(OrderModel order) {
    box.add(order.toMap());
    loadOrders();
  }
}