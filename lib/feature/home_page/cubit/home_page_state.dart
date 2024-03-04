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
      this.selectionButton = false,
      this.admissionButton = false,
      this.movingButton = false,
      this.returningButton = false,
      this.rechargeButton = false,
      this.itsMezonine = true,
      this.cameraScaner = false,
      this.refreshTime = 10});

  final String username;
  final HomePageStatus status;
  final bool selectionButton;
  final bool admissionButton;
  final bool movingButton;
  final bool returningButton;
  final bool rechargeButton;
  final bool cameraScaner;
  final bool itsMezonine;
  final int refreshTime;

  HomePageState copyWith(
      {String? username,
      HomePageStatus? status,
      bool? selectionButton,
      bool? admissionButton,
      bool? movingButton,
      bool? returningButton,
      bool? rechargeButton,
      bool? itsMezonine,
      bool? cameraScaner,
      int? refreshTime}) {
    return HomePageState(
        username: username ?? this.username,
        status: status ?? this.status,
        selectionButton: selectionButton ?? this.selectionButton,
        admissionButton: admissionButton ?? this.admissionButton,
        movingButton: movingButton ?? this.movingButton,
        returningButton: returningButton ?? this.returningButton,
        rechargeButton: rechargeButton ?? this.rechargeButton,
        itsMezonine: itsMezonine ?? this.itsMezonine,
        cameraScaner: cameraScaner ?? this.cameraScaner,
        refreshTime: refreshTime ?? this.refreshTime);
  }

  @override
  List<Object?> get props => [
        username,
        status,
        selectionButton,
        admissionButton,
        movingButton,
        returningButton,
        rechargeButton,
        itsMezonine,
        cameraScaner,
        refreshTime
      ];
}
