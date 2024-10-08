import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../api_client/client.dart';
import '../model/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> loadOrder(String routeGuid) async {
    final client = ApiClient();

    emit(OrderLoading());
    try {
      // Fetch route data with orders
      final RouteData routeDataList = await client.fetchOrderData(routeGuid);
      if (routeDataList.errorMassage != 'OK') {
        emit(OrderError(routeDataList.errorMassage));
        return;
      }
      if (routeDataList.docId.isNotEmpty) {
        final routeData =
            routeDataList; // Assuming you need the first one from the list
        emit(OrderLoaded(
          routeData: routeData,
          orders: routeData.data, // Orders are stored in routeData.data
        ));
      } else {
        emit(OrderError('No order found'));
      }
    } catch (e) {
      emit(OrderError('Failed to load order: $e'));
    }
  }

  Future<bool> startScan(String routeGuid) async {
    final client = ApiClient();
    emit(OrderLoading());

    final RouteData routeDataList = await client.createRouteDoc(routeGuid);
    if (routeDataList.errorMassage != 'OK') {
      emit(OrderError(routeDataList.errorMassage));
      return false;
    }

    emit(OrderLoaded(routeData: routeDataList, orders: []));
    return true;
  }

  Future<bool> routeScan(
      String routeGuid, String barcode, String docGuid) async {
    final client = ApiClient();

    var errorMassage = await client.routeScan(routeGuid, barcode, docGuid);
    if (errorMassage != 'OK') {
      emit(OrderError(errorMassage));
      return false;
    }
    return true;
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
