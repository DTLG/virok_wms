import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';

import '../api_client/client.dart';
import '../model/order_route_info.dart';

part 'order_route_info_state.dart';

final SoundInterface _soundInterface = SoundInterface();

class OrderRouteInfoCubit extends Cubit<OrderRouteInfoState> {
  OrderRouteInfoCubit() : super(OrderRouteInfoInitial());

  Future<void> fetchOrderRouteInfo(String orderId) async {
    final client = ApiClient();
    emit(OrderRouteInfoLoading());

    try {
      final OrderRouteInfo res = await client.getRouteInfo(orderId);

      emit(OrderRouteInfoLoaded(res));
    } catch (e) {
      emit(OrderRouteInfoError(
          "Виникла помилка під час спроби отримати інформацію"));
      _soundInterface.play(Event.error);
    }
  }
}
