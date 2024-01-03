import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page_api_client/home_page_api_client.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username') ?? '';
    emit(state.copyWith(
      status: HomePageStatus.success,
      username: username,
    ));
  }



  Future<void> getActivButton() async {
    final prefs = await SharedPreferences.getInstance();
    final bool selectionButton = prefs.getBool('selection_button') ?? false;
    final bool admissionButton = prefs.getBool('admission_button') ?? false;
    final bool movingButton = prefs.getBool('moving_button') ?? false;
    final bool returningButton = prefs.getBool('returning_button') ?? false;

    final bool rechargeButton = prefs.getBool('recharge_button') ?? false;
    final bool cameraScaner = prefs.getBool('camera_scaner') ?? false;

    emit(state.copyWith(
        selectionButton: selectionButton,
        admissionButton: admissionButton,
        movingButton: movingButton,
        returningButton: returningButton,
        rechargeButton: rechargeButton,
        cameraScaner: cameraScaner,
        status: HomePageStatus.success));
  }

  Future<void> checkTsdType() async {
    try {
      bool itsMezonine = await HomePageApiCLient().checkTsdType();
      emit(state.copyWith(
          itsMezonine: itsMezonine, status: HomePageStatus.success));
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('its_mezonine', itsMezonine);
    } catch (e) {
      emit(state.copyWith(status: HomePageStatus.failure));
    }
  }
}
