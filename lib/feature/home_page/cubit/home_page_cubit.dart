import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final bool routes = prefs.getBool('routes') ?? false;
    final bool movingButton = prefs.getBool('moving_button') ?? false;
    final bool returningButton = prefs.getBool('returning_button') ?? false;
    final bool npTtnPrintButton = prefs.getBool('np_ttn_print_button') ?? false;
    final bool meestTtnPrintButton =
        prefs.getBool('meest_ttn_print_button') ?? false;
    final bool labelPrintButton = prefs.getBool('label_print_button') ?? false;
    final bool rechargeButton = prefs.getBool('recharge_button') ?? false;
    final bool epicenter_button = prefs.getBool('epicenter_button') ?? false;
    final bool movingDefectiveButton =
        prefs.getBool('moving_defective_button') ?? false;
    final bool cameraScaner = prefs.getBool('camera_scaner') ?? false;

    emit(state.copyWith(
        selectionButton: selectionButton,
        admissionButton: admissionButton,
        routes: routes,
        movingButton: movingButton,
        returningButton: returningButton,
        npTtnPrintButton: npTtnPrintButton,
        meestTtnPrintButton: meestTtnPrintButton,
        labelPrintButton: labelPrintButton,
        rechargeButton: rechargeButton,
        cameraScaner: cameraScaner,
        movingDefectiveButton: movingDefectiveButton,
        epicenter: epicenter_button,
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

  // Future<void> forceFetchPathesCollection() async {
  //   try {
  //     emit(state.copyWith(status: LoginStatus.loading));
  //     final CollectionReference pathesCollection =
  //         FirebaseFirestore.instance.collection('pathes');

  //     QuerySnapshot snapshot = await pathesCollection.get();

  //     List<Map<String, dynamic>> pathes = snapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();

  //     emit(state.copyWith(
  //       pathes: pathes,
  //       status: LoginStatus.succsses,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //         status: LoginStatus.failure,
  //         time: DateTime.now().millisecondsSinceEpoch));
  //   }
  // }

  Future<String?> getPass() async {
    final CollectionReference passwordsCollection =
        FirebaseFirestore.instance.collection('passwords');

    // Get all documents from the passwords collection
    QuerySnapshot snapshot = await passwordsCollection.get();

    if (snapshot.docs.isNotEmpty) {
      // Assuming each doc contains a map and 'active' is the field we need
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      return data['active'] as String?;
    } else {
      return null; // Return null if there are no documents
    }
  }
}
