// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:meta/meta.dart';

import '../../../../core/constant.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUSeCase;
  final LoginUseCase loginUSeCase;
  final _storage = FlutterSecureStorage();
  final AuthLocalDatasource _authLocal = AuthLocalDatasource();
  AuthBloc({
    required this.registerUSeCase,
    required this.loginUSeCase,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await registerUSeCase(event.username, event.email, event.password);
      emit(AuthSuccess(message: "Registered successfully"));
    } catch (e) {
      emit(AuthFailure(error: "Register failed"));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUSeCase(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: StorageKeys.userId, value: user.id.toString());
      emit(AuthSuccess(message: "Login successfully"));
    } catch (e) {
      log(e.toString());
      emit(AuthFailure(error: "Login failed: ${e.toString()}"));
    }
  }

  //logout
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authLocal.deleteToken();
      emit(AuthSuccess(message: "Logout successfully"));
    } catch (e) {
      //log error details
      log(e.toString());
      emit(AuthFailure(error: "Logout failed"));
    }
  }
}
