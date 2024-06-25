import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virok_wms/feature/settings/models/device_ids.dart';
import 'package:virok_wms/utils.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final dbPath = prefs.getString('api') ?? '';
    final generationButton = prefs.getBool('generation_bar_button') ?? false;
    final printButton = prefs.getBool('barcode_print_lable_button') ?? false;
    final cellInfoButton = prefs.getBool('cell_info_button') ?? false;
    final basketInfoButton = prefs.getBool('basket_info_button') ?? false;
    final basketOperation = prefs.getBool('basketOperation') ?? false;

    final cellGeneratorButton = prefs.getBool('cell_generator_button') ?? false;

    final placementButton = prefs.getBool('placement_button') ?? false;
    final writeOffButton = prefs.getBool('writing_off_button') ?? false;

    final selectionButton = prefs.getBool('selection_button') ?? false;
    final admissionButton = prefs.getBool('admission_button') ?? false;
    final movingButton = prefs.getBool('moving_button') ?? false;
    final returningButton = prefs.getBool('returning_button') ?? false;

    final rechargeButton = prefs.getBool('recharge_button') ?? false;
    final cameraScaner = prefs.getBool('camera_scaner') ?? false;

    final printerHost = prefs.getString('printer_host') ?? '';
    final printerPort = prefs.getString('printer_port') ?? '9100';
    final refreshTime = prefs.getInt('refreshTime') ?? 10;
    final deviceId = prefs.getString('deviceId') ?? '';

    emit(state.copyWith(
        status: SettingsStatus.success,
        dbPath: dbPath,
        generationButton: generationButton,
        printButton: printButton,
        cellInfoButton: cellInfoButton,
        basketInfoButton: basketInfoButton,
        cellGeneratorButton: cellGeneratorButton,
        placementButton: placementButton,
        writeOffButton: writeOffButton,
        selectionButton: selectionButton,
        admissionButton: admissionButton,
        basketOperation: basketOperation,
        movingButton: movingButton,
        returningButton: returningButton,
        rechargeButton: rechargeButton,
        printerHost: printerHost,
        printerPort: printerPort,
        cameraScaner: cameraScaner,
        autoRefreshTime: refreshTime,
        deviceId: deviceId));
  }

  Future<void> writeToSP(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
    switch (key) {
      case 'barcode_print_lable_button':
        return emit(state.copyWith(printButton: value));
      case 'basketOperation':
        return emit(state.copyWith(basketOperation: value));
      case 'cell_info_button':
        return emit(state.copyWith(cellInfoButton: value));
      case 'basket_info_button':
        return emit(state.copyWith(basketInfoButton: value));
      case 'cell_generator_button':
        return emit(state.copyWith(cellGeneratorButton: value));
      case 'generation_bar_button':
        return emit(state.copyWith(generationButton: value));
      case 'placement_button':
        return emit(state.copyWith(placementButton: value));
      case 'writing_off_button':
        return emit(state.copyWith(writeOffButton: value));
      case 'selection_button':
        return emit(state.copyWith(selectionButton: value));
      case 'admission_button':
        return emit(state.copyWith(admissionButton: value));
      case 'moving_button':
        return emit(state.copyWith(movingButton: value));
      case 'recharge_button':
        return emit(state.copyWith(rechargeButton: value));
      case 'camera_scaner':
        return emit(state.copyWith(cameraScaner: value));
      case 'returning_button':
        return emit(state.copyWith(returningButton: value));
    }
  }

  changeRefreshTime(int newTime) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('refreshTime', newTime);

    emit(state.copyWith(autoRefreshTime: newTime));
  }

  Future<void> setStorage(Storages value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('storage', value.name);
    emit(state.copyWith(storage: value));
  }

  Future<void> getStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('storage') ?? 'lviv';
    emit(state.copyWith(storage: value.toStorage));
  }
}
