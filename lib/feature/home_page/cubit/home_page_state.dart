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
  const HomePageState({
    this.zone = '',
    this.status = HomePageStatus.initial,
    this.selectionButton = false,
    this.npTtnPrintButton = false,
    this.meestTtnPrintButton = false,
    this.admissionButton = false,
    this.movingButton = false,
    this.returningButton = false,
    this.rechargeButton = false,
    this.itsMezonine = true,
    this.cameraScaner = false,
    this.refreshTime = 10,
  });

  final String zone;
  final HomePageStatus status;
  final bool selectionButton;
  final bool admissionButton;
  final bool movingButton;
  final bool returningButton;
  final bool npTtnPrintButton;
  final bool meestTtnPrintButton;
  final bool rechargeButton;
  final bool cameraScaner;
  final bool itsMezonine;
  final int refreshTime;

  HomePageState copyWith({
    String? zone,
    HomePageStatus? status,
    bool? selectionButton,
    bool? admissionButton,
    bool? movingButton,
    bool? returningButton,
    bool? npTtnPrintButton,
    bool? meestTtnPrintButton,
    bool? rechargeButton,
    bool? itsMezonine,
    bool? cameraScaner,
    int? refreshTime,
    int? count,
  }) {
    return HomePageState(
        zone: zone ?? this.zone,
        status: status ?? this.status,
        selectionButton: selectionButton ?? this.selectionButton,
        admissionButton: admissionButton ?? this.admissionButton,
        movingButton: movingButton ?? this.movingButton,
        returningButton: returningButton ?? this.returningButton,
        npTtnPrintButton: npTtnPrintButton ?? this.npTtnPrintButton,
        meestTtnPrintButton: meestTtnPrintButton ?? this.meestTtnPrintButton,
        rechargeButton: rechargeButton ?? this.rechargeButton,
        itsMezonine: itsMezonine ?? this.itsMezonine,
        cameraScaner: cameraScaner ?? this.cameraScaner,
        refreshTime: refreshTime ?? this.refreshTime);
  }

  @override
  List<Object?> get props => [
        zone,
        status,
        selectionButton,
        admissionButton,
        movingButton,
        returningButton,
        npTtnPrintButton,
        rechargeButton,
        itsMezonine,
        cameraScaner,
        refreshTime
      ];
}
