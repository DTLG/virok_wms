part of 'home_page_cubit.dart';

enum HomePageStatus { success, initial, verificationTrue, verification }

extension HomePageStatusX on HomePageStatus {
  bool get isInitial => this == HomePageStatus.initial;
  bool get isSuccess => this == HomePageStatus.success;
}

final class HomePageState extends Equatable {
  const HomePageState(
      {this.username = '',
      this.status = HomePageStatus.initial,
      this.genBarButton = false,
      this.cellInfoButton = false,
      this.barcodeLablePrintButton = false});

  final String username;
  final HomePageStatus status;
  final bool genBarButton;
  final bool barcodeLablePrintButton;
  final bool cellInfoButton;

  HomePageState copyWith(
      {String? username,
      HomePageStatus? status,
      bool? genBarButton,
      bool? barcodeLablePrintButton,
      bool? cellInfoButton}) {
    return HomePageState(
        username: username ?? this.username,
        status: status ?? this.status,
        genBarButton: genBarButton ?? this.genBarButton,
        cellInfoButton: cellInfoButton ?? this.cellInfoButton,
        barcodeLablePrintButton:
            barcodeLablePrintButton ?? this.barcodeLablePrintButton);
  }

  @override
  List<Object?> get props =>
      [username, status, genBarButton, barcodeLablePrintButton, cellInfoButton];
}
