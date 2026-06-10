import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/product_api_service.dart';

import 'product_state.dart';

class ProductCubit
    extends Cubit<ProductState> {

  ProductCubit()
      : super(ProductInitial());

  final ProductApiService
      productApiService =
          ProductApiService();

  Future<void> getProducts() async {

    try {

      emit(ProductLoading());

      final products =
          await productApiService
              .getProducts();

      emit(
        ProductLoaded(products),
      );

    } catch (e) {

      emit(

        ProductError(
          "Failed to load products",
        ),

      );

    }

  }

}