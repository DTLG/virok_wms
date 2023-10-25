part of 'home_page_cubit.dart';

enum HomePageStatus {
  success,
  initial,
  verificationTrue,
  verification,
  failure
}

extension HomePageStatusX on HomePageStatus {
  bool get isInitial => this == HomePageStatus.initial;
  bool get isSuccess => this == HomePageStatus.success;
  bool get isFailure => this == HomePageStatus.failure;
}

final class HomePageState extends Equatable {
  const HomePageState(
      {this.username = '',
      this.status = HomePageStatus.initial,
      this.genBarButton = false,
      this.cellInfoButton = false,
      this.basketInfoButton = false,
      this.itsMezonine = true,
      this.barcodeLablePrintButton = false});

  final String username;
  final HomePageStatus status;
  final bool genBarButton;
  final bool barcodeLablePrintButton;
  final bool cellInfoButton;
  final bool basketInfoButton;

  final bool itsMezonine;

  HomePageState copyWith(
      {String? username,
      HomePageStatus? status,
      bool? genBarButton,
      bool? barcodeLablePrintButton,
      bool? cellInfoButton,
      bool? basketInfoButton,
      bool? itsMezonine}) {
    return HomePageState(
        username: username ?? this.username,
        status: status ?? this.status,
        genBarButton: genBarButton ?? this.genBarButton,
        cellInfoButton: cellInfoButton ?? this.cellInfoButton,
        barcodeLablePrintButton:
            barcodeLablePrintButton ?? this.barcodeLablePrintButton,
        basketInfoButton: basketInfoButton ?? this.basketInfoButton,
        itsMezonine: itsMezonine ?? this.itsMezonine);
  }

  @override
  List<Object?> get props => [
        username,
        status,
        genBarButton,
        barcodeLablePrintButton,
        cellInfoButton,
        basketInfoButton,
        itsMezonine
      ];
}
