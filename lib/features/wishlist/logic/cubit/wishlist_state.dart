import 'package:equatable/equatable.dart';
import '../../data/models/wishlist_item_model.dart';

abstract class WishlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItemModel> items;

  WishlistLoaded(this.items);

  @override
  List<Object?> get props => [items];
}