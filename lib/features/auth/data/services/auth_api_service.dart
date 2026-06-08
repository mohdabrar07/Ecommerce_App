import 'package:dio/dio.dart';

import 'package:ecommerce_app/core/constants/api_constants.dart';
import 'package:ecommerce_app/core/network/dio_client.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthApiService {

  final Dio dio = DioClient().dio;

  Future<LoginResponseModel> login(
      LoginRequestModel request) async {

    final response = await dio.post(

      ApiConstants.login,

      data: request.toJson(),

    );

    return LoginResponseModel.fromJson(
      response.data,
    );

  }

  Future<UserModel> getProfile(
      String token) async {

    final response = await dio.get(

      ApiConstants.profile,

      options: Options(

        headers: {

          "Authorization":
              "Bearer $token",

        },

      ),

    );

    return UserModel.fromJson(
      response.data,
    );

  }

}