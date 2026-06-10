import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../data/models/wishlist_item_model.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial()) {
    loadWishlist();
  }

  final box = Hive.box('wishlistBox');

  void loadWishlist() {
    final data = box.values.toList();

    final items = data
        .map((e) => WishlistItemModel.fromMap(Map.from(e)))
        .toList();

    emit(WishlistLoaded(items));
  }

  void toggleWishlist(WishlistItemModel item) {
    final current = state;

    if (current is WishlistLoaded) {
      final items = List<WishlistItemModel>.from(current.items);

      final index = items.indexWhere((e) => e.id == item.id);

      if (index != -1) {
        items.removeAt(index);
      } else {
        items.add(item);
      }

      box.clear();

      for (var i in items) {
        box.add(i.toMap());
      }

      emit(WishlistLoaded(items));
    }
  }
}