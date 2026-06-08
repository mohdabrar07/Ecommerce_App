import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/login_request_model.dart';
import '../../data/services/auth_api_service.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>{
  AuthCubit():super(AuthInitial());

  final AuthApiService authApiService=AuthApiService();

  Future<void> login({ 
    required String email,
    required String password,
  })async{
    try{
      emit(AuthLoading());
      final response=await authApiService.login(
        LoginRequestModel(
          email:email,
          password:password,
        ),
      );
      final box=await  Hive.openBox('appBox');
      await box.put(
        'token',
        response.accessToken,
      );
      emit(AuthSuccess());
    }catch(e){
      emit(AuthError(
        e.toString(),
      ),
      );
    }
    }
  }
