import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/login/api/login_api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> login(String username, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      final res = await LoginApi().logIn(username, password);
      if (res == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        emit(state.copyWith(status: LoginStatus.login));
        
      } else if (res >= 400 && res < 500) {
        emit(state.copyWith(status: LoginStatus.loading));

        emit(state.copyWith(status: LoginStatus.unknown));
      } else {
        emit(state.copyWith(status: LoginStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
