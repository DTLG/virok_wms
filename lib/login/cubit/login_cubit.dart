import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/login/api/login_api.dart';
import 'package:virok_wms/login/login_repo.dart';

import '../users.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  writeZone(String zone) {
    emit(state.copyWith(zone: zone, status: LoginStatus.succsses));
  }

  Future<void> getUsers(String path) async {
    try {
      final users = await LoginRepo().getUsers(path);
      emit(state.copyWith(users: users, status: LoginStatus.succsses));
    } catch (e) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }

  void writeDbPath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('api');
    emit(state.copyWith(dbPath: path, status: LoginStatus.a));
  }

  Future<void> login(String zone, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      final res = await LoginApi().logIn(zone, password);
      if (res == 200) {
        bool itsMezonine = await LoginApi().checkTsdType(zone, password);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('zone', zone);
        await prefs.setString('password', password);
        await prefs.setBool('its_mezonine', itsMezonine);

        emit(state.copyWith(status: LoginStatus.login));
      } else if (res >= 400 && res < 500) {
        emit(state.copyWith(status: LoginStatus.loading));

        emit(state.copyWith(
            status: LoginStatus.unknown,
            time: DateTime.now().millisecondsSinceEpoch));
      } else {
        emit(state.copyWith(
            status: LoginStatus.failure,
            time: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }
}
