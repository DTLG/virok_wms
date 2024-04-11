import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/auth/auth_client/auth_client.dart';
import 'package:virok_wms/auth/auth_client/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  selectPath(String path) async {
    emit(state.copyWith(
        status: AuthStatus.succsses,
        dbPath: path,
        time: DateTime.now().millisecondsSinceEpoch));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('api', path);

    await getZones(path);
  }

  Future<void> getZones(String path) async {
    try {
      final zones = await AuthClient().getZones(path);
      emit(state.copyWith(
          usersAndZones: zones,
          time: DateTime.now().millisecondsSinceEpoch,
          status: AuthStatus.succsses));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: e.toString()));
    }
  }

  selectUser(String user) {
    emit(state.copyWith(
        user: user,
        time: DateTime.now().millisecondsSinceEpoch,
        status: AuthStatus.succsses));
  }

  selectZone(String zone) {
    emit(state.copyWith(
        zone: zone,
        time: DateTime.now().millisecondsSinceEpoch,
        status: AuthStatus.succsses));
  }

  changeZonePass(String pass) {
    emit(state.copyWith(
        userPass: pass,
        time: DateTime.now().millisecondsSinceEpoch,
        status: AuthStatus.succsses));
  }

  changeDeviceId(String id) async {
    emit(state.copyWith(
        deviceId: id,
        time: DateTime.now().millisecondsSinceEpoch,
        status: AuthStatus.succsses));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceId', id);
  }

  Future<void> logIn() async {
    try {
      emit(state.copyWith(
        status: AuthStatus.loading,
        time: DateTime.now().millisecondsSinceEpoch,
      ));

      final logInStatus = await AuthClient()
          .logIn(state.dbPath, state.zone, state.userPass, state.user);
      if (logInStatus == "OK") {
        bool itsMezonine =
            await AuthClient().checkTsdType(state.user, state.zone);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('zone', state.zone);
        await prefs.setString('user', state.user);
        await prefs.setString('password', state.userPass);
        await prefs.setBool('its_mezonine', itsMezonine);

        emit(state.copyWith(
            status: AuthStatus.login,
            time: DateTime.now().millisecondsSinceEpoch));
        return;
      }

      emit(state.copyWith(
          status: AuthStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: logInStatus));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch,
          errorMassage: e.toString()));
    }
  }
}
