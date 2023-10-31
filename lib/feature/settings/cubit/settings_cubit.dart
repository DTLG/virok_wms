import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final printerHost = prefs.getString('printer_host') ?? '';
    final printerPort = prefs.getString('printer_port') ?? '9100';

    emit(state.copyWith(
        status: SettingsStatus.success,
        dbPath: dbPath,
        generationButton: generationButton,
        printButton: printButton,
        cellInfoButton: cellInfoButton,
        basketInfoButton: basketInfoButton,
        printerHost: printerHost,
        printerPort: printerPort));
  }
}
