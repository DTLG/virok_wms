import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virok_wms/feature/moving_defective_page/widget/toast.dart';
import 'package:virok_wms/ui/widgets/sound_interface.dart';

import '../api_client/client.dart';
import '../model/order.dart';

part 'order_state.dart';

final SoundInterface _soundInterface = SoundInterface();

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> loadOrder(String cell_barcode) async {
    final client = ApiClient();

    emit(OrderLoading());
    try {
      // Fetch route data with orders
      final RouteData routeDataList = await client.fetchOrderData(cell_barcode);
      if (routeDataList.errorMassage != "OK") {
        emit(OrderError(routeDataList.errorMassage));
        _soundInterface.play(Event.error);
        return;
      }
      // if (routeDataList.data.isNotEmpty) {
      //   getRouteInfo(routeDataList.data.first.orderBarcode);
      // }
      emit(OrderLoaded(
        routeData: routeDataList,
        orders: routeDataList.data, // Orders are stored in routeData.data
      ));
      // if (routeDataList.docId.isNotEmpty) {
      //   final routeData =
      //       routeDataList; // Assuming you need the first one from the list
      //   emit(OrderLoaded(
      //     routeData: routeData,
      //     orders: routeData.data, // Orders are stored in routeData.data
      //   ));
      // } else {
      //   emit(OrderError('No order found'));
      // }
    } catch (e) {
      emit(OrderError('Failed to load order: $e'));
      _soundInterface.play(Event.error);
    }
  }

  Future<bool> startScan(String routeGuid) async {
    final client = ApiClient();
    emit(OrderLoading());

    final RouteData routeDataList = await client.createRouteDoc(routeGuid);
    if (routeDataList.errorMassage != 'OK') {
      _soundInterface.play(Event.error);

      emit(OrderError(routeDataList.errorMassage));
      return false;
    }

    emit(OrderLoaded(routeData: routeDataList, orders: []));
    return true;
  }

  // Future<void> getRouteInfo(String? barcode) async {
  //   final client = ApiClient();
  //   try {
  //     if (barcode == null) return;
  //     final String? response = await client.getRouteInfo(barcode);
  //     if (response == "Завершений") {
  //       emit(OrderError('Маршрут вже зайнятий'));
  //     }
  //   } catch (e) {
  //     emit(OrderError(e.toString()));
  //   }
  // }

  Future<bool> routeScan(
      String routeGuid, String barcode, String docGuid) async {
    final client = ApiClient();

    var errorMassage = await client.routeScan(routeGuid, barcode, docGuid);
    if (errorMassage.errorMassage != "OK") {
      _soundInterface.play(Event.error);

      showToast(errorMassage.errorMassage);
      // emit(OrderError(errorMassage.errorMassage));
      return false;
    }
    emit(OrderLoaded(routeData: errorMassage, orders: errorMassage.data));
    return true;
  }

  Future<String> closeRouteDoc(String docGuid) async {
    final client = ApiClient();

    String doc = await client.closeRouteDoc(docGuid);
    showToast(doc);
    if (doc != 'OK') {
      _soundInterface.play(Event.error);

      showToast(doc);
      // emit(OrderError(doc));
    }
    return doc;
  }

  void reviewAllOrders() {
    final currentState = state;
    if (currentState is OrderLoaded) {
      emit(OrderReview(
        routeData: currentState.routeData,
        orders: currentState.orders,
      ));
    }
  }

  void backToLoaded() {
    final currentState = state;
    if (currentState is OrderReview) {
      emit(OrderLoaded(
        routeData: currentState.routeData,
        orders: currentState.orders,
      ));
    }
  }
  // Method to update an order's scanned count within the list
  // void updateScannedCount(String orderId, int newScannedCount) {
  //   if (state is OrderLoaded) {
  //     final currentState = state as OrderLoaded;
  //     final updatedOrders = currentState.orders.map((order) {
  //       // Update the scanned count for the specific order
  //       if (order.docId == orderId) {
  //         return order.copyWith(scannedCount: newScannedCount);
  //       }
  //       return order;
  //     }).toList();

  //     emit(currentState.copyWith(orders: updatedOrders));
  //   }
  // }

  // Method to update order places count for a specific order
  // void updateOrderPlacesCount(String orderId, int newOrderPlacesCount) {
  //   if (state is OrderLoaded) {
  //     final currentState = state as OrderLoaded;
  //     final updatedOrders = currentState.orders.map((order) {
  //       if (order.id == orderId) {
  //         return order.copyWith(orderPlacesCount: newOrderPlacesCount);
  //       }
  //       return order;
  //     }).toList();

  //     emit(currentState.copyWith(orders: updatedOrders));
  //   }
  // }
}
