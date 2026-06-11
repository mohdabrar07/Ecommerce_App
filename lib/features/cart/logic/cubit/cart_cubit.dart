import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import '../../data/models/cart_item_model.dart';
import 'package:hive/hive.dart';

class CartCubit extends Cubit<CartState> {
  final Box box = Hive.box('cartBox');

  CartCubit() : super(CartInitial()) {
    loadCart();
  }

  void loadCart() {
    final data = box.values.toList();
    final items = data
        .map((e) => CartItemModel.fromMap(Map.from(e as Map)))
        .toList();

    if (items.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartLoaded(items));
    }
  }

  void addToCart(CartItemModel item) {
    List<CartItemModel> items = [];
    
    if (state is CartLoaded) {
      items = List<CartItemModel>.from((state as CartLoaded).items);
    } else if (state is CartEmpty || state is CartInitial) {
      items = [];
    } else {
      return;
    }

    final index = items.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      // Create a fresh instance using copyWith to update state cleanly
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + item.quantity,
      );
    } else {
      items.add(item);
    }

    _save(items);
  }

  void increase(int id) {
    if (state is CartLoaded) {
      final items = List<CartItemModel>.from((state as CartLoaded).items);
      final index = items.indexWhere((e) => e.id == id);
      
      if (index != -1) {
        items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
        _save(items);
      }
    }
  }

  void decrease(int id) {
    if (state is CartLoaded) {
      final items = List<CartItemModel>.from((state as CartLoaded).items);
      final index = items.indexWhere((e) => e.id == id);
      
      if (index != -1) {
        if (items[index].quantity > 1) {
          items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
          _save(items);
        } else {
          // If quantity drops below 1, remove item entirely from cart
          remove(id);
        }
      }
    }
  }

  void remove(int id) {
    if (state is CartLoaded) {
      final items = (state as CartLoaded).items.where((e) => e.id != id).toList();
      _save(items);
    }
  }

  void _save(List<CartItemModel> items) {
    box.clear();
    for (var item in items) {
      box.add(item.toMap());
    }
    
    if (items.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartLoaded(items));
    }
  }
}