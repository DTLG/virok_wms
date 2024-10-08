part of 'routes_cubit.dart';

@immutable
abstract class RoutesState extends Equatable {
  @override
  List<Object> get props => [];
}

class RoutesInitial extends RoutesState {}

class RoutesLoading extends RoutesState {}

class RoutesLoaded extends RoutesState {
  final List<MyRoute> routes;
  final List<MyRoute> rootFolders;
  final Map<String, bool> expandedFolders;

  RoutesLoaded({
    required this.routes,
    required this.rootFolders,
    required this.expandedFolders,
  });
}

class RoutesError extends RoutesState {
  final String message;

  RoutesError({required this.message});

  @override
  List<Object> get props => [message];
}
