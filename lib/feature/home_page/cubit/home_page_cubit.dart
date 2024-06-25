import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageState());

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String zone = prefs.getString('zone') ?? '';
    emit(state.copyWith(
      status: HomePageStatus.success,
      zone: zone,
    ));
  }

  Future<void> getRefreshTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int refreshTime = prefs.getInt('refreshTime') ?? 10;
    emit(state.copyWith(refreshTime: refreshTime));
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
      final prefs = await SharedPreferences.getInstance();
      final itsMezonine = prefs.getBool('its_mezonine') ?? false;
      emit(state.copyWith(
          itsMezonine: itsMezonine, status: HomePageStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomePageStatus.failure));
    }
  }
}
