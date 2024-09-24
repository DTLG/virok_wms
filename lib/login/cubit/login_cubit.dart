import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      String responseData = res.reasonPhrase.toString();
      if (res.statusCode == 200) {
        if (responseData == 'OK') {
          bool itsMezonine = await LoginApi().checkTsdType(zone, password);
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('zone', zone);
          await prefs.setString('password', password);
          await prefs.setBool('its_mezonine', itsMezonine);

          emit(state.copyWith(status: LoginStatus.login));
        } else {
          emit(state.copyWith(
              status: LoginStatus.unknown,
              time: DateTime.now().millisecondsSinceEpoch));
        }
        // } else if (res.statusCode >= 400 && res.statusCode < 500) {
      } else if (responseData == 'Unauthorized') {
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

  Future<void> fetchPathesCollection() async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedPathesJson = prefs.getString('pathes');

      if (savedPathesJson != null) {
        // Parse the saved JSON data
        List<Map<String, dynamic>> savedPathes =
            List<Map<String, dynamic>>.from(
          (jsonDecode(savedPathesJson) as List)
              .map((item) => item as Map<String, dynamic>),
        );
        emit(state.copyWith(
          pathes: savedPathes,
          status: LoginStatus.succsses,
        ));
      } else {
        // Fetch data from Firestore
        final CollectionReference pathesCollection =
            FirebaseFirestore.instance.collection('pathes');

        QuerySnapshot snapshot = await pathesCollection.get();

        List<Map<String, dynamic>> pathes = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Save the fetched data to SharedPreferences
        await prefs.setString('pathes', jsonEncode(pathes));

        emit(state.copyWith(
          pathes: pathes,
          status: LoginStatus.succsses,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }

  Future<void> forceFetchPathesCollection() async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      final CollectionReference pathesCollection =
          FirebaseFirestore.instance.collection('pathes');

      QuerySnapshot snapshot = await pathesCollection.get();

      List<Map<String, dynamic>> pathes = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      emit(state.copyWith(
        pathes: pathes,
        status: LoginStatus.succsses,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: LoginStatus.failure,
          time: DateTime.now().millisecondsSinceEpoch));
    }
  }
}
