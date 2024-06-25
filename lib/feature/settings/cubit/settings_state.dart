part of 'settings_cubit.dart';

enum SettingsStatus { initial, success }

extension SettingsStatusX on SettingsStatus {
  bool get isInitial => this == SettingsStatus.initial;
  bool get isSuccess => this == SettingsStatus.success;
}

class SettingsState extends Equatable {
  final SettingsStatus status;
  final String dbPath;
  final bool generationButton;
  final bool printButton;
  final bool cellInfoButton;
  final bool basketInfoButton;
  final bool cellGeneratorButton;
  final bool placementButton;
  final bool writeOffButton;
  final bool selectionButton;
  final bool admissionButton;
  final bool movingButton;
  final bool returningButton;
  final bool rechargeButton;
  final bool cameraScaner;
  final bool basketOperation;

  final String printerHost;
  final String printerPort;
  final String errorCounter;
  final String errorCounterH;
  final String scanH;
  final String scan;
  final int autoRefreshTime;

  final String deviceId;
  final DeviceIds deviceIds;

  final Storages storage;

  const SettingsState(
      {this.status = SettingsStatus.initial,
      this.dbPath = '',
      this.generationButton = false,
      this.printButton = false,
      this.cellInfoButton = false,
      this.basketInfoButton = false,
      this.cellGeneratorButton = false,
      this.placementButton = false,
      this.writeOffButton = false,
      this.selectionButton = false,
      this.admissionButton = false,
      this.movingButton = false,
      this.rechargeButton = false,
      this.returningButton = false,
      this.basketOperation = false,
      this.printerHost = '',
      this.printerPort = '',
      this.cameraScaner = false,
      this.errorCounter = '',
      this.errorCounterH = '',
      this.scan = '',
      this.scanH = '',
      this.autoRefreshTime = 10,
      this.deviceId = '',
      this.storage = Storages.lviv,
      DeviceIds? deviceIds})
      : deviceIds = deviceIds ?? DeviceIds.empty;

  SettingsState copyWith(
      {SettingsStatus? status,
      String? dbPath,
      bool? generationButton,
      bool? printButton,
      bool? cellInfoButton,
      bool? basketInfoButton,
      bool? cellGeneratorButton,
      bool? placementButton,
      bool? writeOffButton,
      bool? selectionButton,
      bool? admissionButton,
      bool? movingButton,
      bool? returningButton,
      bool? rechargeButton,
      bool? basketOperation,
      String? printerHost,
      String? printerPort,
      bool? cameraScaner,
      String? errorCounter,
      String? errorCounterH,
      String? scan,
      String? scanH,
      int? autoRefreshTime,
      String? deviceId,
      DeviceIds? deviceIds,
      Storages? storage}) {
    return SettingsState(
        status: status ?? this.status,
        dbPath: dbPath ?? this.dbPath,
        generationButton: generationButton ?? this.generationButton,
        printButton: printButton ?? this.printButton,
        cellInfoButton: cellInfoButton ?? this.cellInfoButton,
        basketInfoButton: basketInfoButton ?? this.basketInfoButton,
        cellGeneratorButton: cellGeneratorButton ?? this.cellGeneratorButton,
        placementButton: placementButton ?? this.placementButton,
        writeOffButton: writeOffButton ?? this.writeOffButton,
        selectionButton: selectionButton ?? this.selectionButton,
        admissionButton: admissionButton ?? this.admissionButton,
        movingButton: movingButton ?? this.movingButton,
        basketOperation: basketOperation ?? this.basketOperation,
        returningButton: returningButton ?? this.returningButton,
        rechargeButton: rechargeButton ?? this.rechargeButton,
        printerHost: printerHost ?? this.printerHost,
        printerPort: printerPort ?? this.printerPort,
        cameraScaner: cameraScaner ?? this.cameraScaner,
        errorCounter: errorCounter ?? this.errorCounter,
        errorCounterH: errorCounterH ?? this.errorCounterH,
        scan: scan ?? this.scan,
        scanH: scanH ?? this.scanH,
        autoRefreshTime: autoRefreshTime ?? this.autoRefreshTime,
        deviceId: deviceId ?? this.deviceId,
        deviceIds: deviceIds ?? this.deviceIds,
        storage: storage ?? this.storage);
  }

  @override
  List<Object?> get props => [
        status,
        dbPath,
        generationButton,
        printButton,
        printerHost,
        printerPort,
        cellInfoButton,
        cellGeneratorButton,
        placementButton,
        writeOffButton,
        basketInfoButton,
        selectionButton,
        admissionButton,
        basketOperation,
        movingButton,
        returningButton,
        rechargeButton,
        cameraScaner,
        errorCounter,
        errorCounterH,
        scan,
        scanH,
        autoRefreshTime,
        deviceId,
        deviceIds,
        storage
      ];
}

