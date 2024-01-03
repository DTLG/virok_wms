import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_operations_state.dart';

class StorageOperationsCubit extends Cubit<StorageOperationsState> {
  StorageOperationsCubit() : super(const StorageOperationsState());
  Future<void> getActivButton() async {
    final prefs = await SharedPreferences.getInstance();
    final bool genBarButton = prefs.getBool('generation_bar_button') ?? false;
    final bool barcodeLablePrintButton =
        prefs.getBool('barcode_print_lable_button') ?? false;
    final bool cellInfoButton = prefs.getBool('cell_info_button') ?? false;
    final bool basketInfoButton = prefs.getBool('basket_info_button') ?? false;
    final bool cellGeneratorButton =
        prefs.getBool('cell_generator_button') ?? false;
        final bool placementButton = prefs.getBool('placement_button') ?? false;
    final bool writingOffButton =
        prefs.getBool('writing_off_button') ?? false;

    emit(state.copyWith(
        genBarButton: genBarButton,
        barcodeLablePrintButton: barcodeLablePrintButton,
        cellInfoButton: cellInfoButton,
        basketInfoButton: basketInfoButton,
        cellGeneratorButton: cellGeneratorButton,
        placementButton: placementButton,
        writingOffButton: writingOffButton));
  }
}
