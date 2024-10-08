import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:virok_wms/feature/routes_page/model/route.dart';

import '../api_client/client.dart';

part 'routes_state.dart';

class RoutesCubit extends Cubit<RoutesState> {
  RoutesCubit() : super(RoutesInitial());

  Future<void> fetchRoutes() async {
    emit(RoutesLoading());
    final client = ApiClient();
    try {
      final response = await client.fetchRoutes();

      if (response == null || response.routes == null) {
        emit(RoutesError(message: 'No routes found'));
        return;
      }

      final List<MyRoute> routes = response.routes;

      final Map<String, List<MyRoute>> childrenMap = {};
      for (final route in routes) {
        if (route.parentGuid != null && route.parentGuid!.isNotEmpty) {
          childrenMap.putIfAbsent(route.parentGuid!, () => []).add(route);
        }
      }

      for (final route in routes) {
        if (childrenMap.containsKey(route.guid)) {
          route.children.addAll(childrenMap[route.guid]!);
        }
      }
      final List<MyRoute> rootFolders =
          routes.where((route) => route.parentGuid == null).toList();

      emit(RoutesLoaded(
        routes: routes,
        expandedFolders: {},
        rootFolders: rootFolders,
      ));
    } catch (e) {
      emit(RoutesError(message: 'Failed to fetch routes: $e'));
    }
  }

  void toggleFolderExpansion(String folderGuid) {
    final currentState = state;
    if (currentState is RoutesLoaded) {
      final expandedFolders =
          Map<String, bool>.from(currentState.expandedFolders);
      if (expandedFolders.containsKey(folderGuid)) {
        expandedFolders.remove(folderGuid);
      } else {
        expandedFolders[folderGuid] = true;
      }
      emit(RoutesLoaded(
        routes: currentState.routes,
        expandedFolders: expandedFolders,
        rootFolders: [],
      ));
    }
  }
}
