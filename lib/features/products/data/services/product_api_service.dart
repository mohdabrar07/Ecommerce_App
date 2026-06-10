import 'package:dio/dio.dart';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/network/dio_client.dart';

import '../models/product_model.dart';

class ProductApiService {

  final Dio dio = DioClient().dio;

  Future<List<ProductModel>>
      getProducts() async {

    final response = await dio.get(
      ApiConstants.products,
    );

    final data = response.data as List;

    return data.map((product) {

      return ProductModel.fromJson(
        product,
      );

    }).toList();

  }

}