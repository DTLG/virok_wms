part of 'check_nom_list_cubit.dart';

enum ChecknomStatus { initial, loading, success, failure, error }

extension ChecknomStatusX on ChecknomStatus {
  bool get isInitial => this == ChecknomStatus.initial;
  bool get isLoading => this == ChecknomStatus.loading;
  bool get isSuccess => this == ChecknomStatus.success;
  bool get isFailure => this == ChecknomStatus.failure;
  bool get isError => this == ChecknomStatus.error;
}

final class CheckNomListState extends Equatable {
  const CheckNomListState(
      {this.status = ChecknomStatus.initial,
      this.errorMassage = '',
      Noms? noms})
      : noms = noms ?? Noms.empty;

  final ChecknomStatus status;
  final Noms noms;
  final String errorMassage;

  CheckNomListState copyWith({
    ChecknomStatus? status,
    Noms? noms,
    String? errorMassage,
  }) {
    return CheckNomListState(
        status: status ?? this.status,
        noms: noms ?? this.noms,
        errorMassage: errorMassage ?? this.errorMassage);
  }

  @override
  List<Object?> get props => [status, noms, errorMassage];
}
