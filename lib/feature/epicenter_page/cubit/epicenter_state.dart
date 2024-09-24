part of 'epicenter_cubit.dart';

// sealed class EpicenterState extends Equatable {
//   const EpicenterState();

//   @override
//   List<Object> get props => [];
// }

// final class EpicenterInitial extends EpicenterState {}

abstract class EpicenterState {}

class EpicenterInitial extends EpicenterState {}

class EpicenterLoading extends EpicenterState {}

class EpicenterLoaded extends EpicenterState {
  final List<Document> documents;

  EpicenterLoaded(this.documents);
}

class EpicenterError extends EpicenterState {
  final String message;

  EpicenterError(this.message);
}
