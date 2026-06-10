import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../../data/models/cart_item_model.dart';
import 'package:hive/hive.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    loadCart();
  }

  final box = Hive.box('cartBox');

  void loadCart() {
    final data = box.values.toList();
    final items = data
        .map((e) => CartItemModel.fromMap(Map.from(e)))
        .toList();

    emit(CartLoaded(items));
  }

  void addToCart(CartItemModel item) {
    final current = state;

    if (current is CartLoaded) {
      final items = List<CartItemModel>.from(current.items);

      final index = items.indexWhere((e) => e.id == item.id);

      if (index != -1) {
        items[index].quantity++;
      } else {
        items.add(item);
      }

      _save(items);
    }
  }

  void increase(int id) {
    final stateData = state;
    if (stateData is CartLoaded) {
      final items = stateData.items;

      for (var item in items) {
        if (item.id == id) item.quantity++;
      }

      _save(items);
    }
  }

  void decrease(int id) {
    final stateData = state;
    if (stateData is CartLoaded) {
      final items = stateData.items;

      for (var item in items) {
        if (item.id == id && item.quantity > 1) {
          item.quantity--;
        }
      }

      _save(items);
    }
  }

  void remove(int id) {
    final stateData = state;
    if (stateData is CartLoaded) {
      final items =
          stateData.items.where((e) => e.id != id).toList();

      _save(items);
    }
  }

  void _save(List<CartItemModel> items) {
    box.clear();
    for (var item in items) {
      box.add(item.toMap());
    }
    emit(CartLoaded(items));
  }
}