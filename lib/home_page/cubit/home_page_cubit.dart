import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final bool genBarButton = prefs.getBool('generation_bar_button') ?? false;
    final bool barcodeLablePrintButton =
        prefs.getBool('barcode_print_lable_button') ?? false;
    final bool cellInfoButton = prefs.getBool('cell_info_button') ?? false;

    emit(state.copyWith(
        genBarButton: genBarButton,
        barcodeLablePrintButton: barcodeLablePrintButton,
        cellInfoButton: cellInfoButton));
  }
}
