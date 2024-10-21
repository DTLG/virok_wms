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
  final bool soundDif;
  final bool taskNumber;
  final bool cellInfoButton;
  final bool basketInfoButton;
  final bool cellGeneratorButton;
  final bool placementButton;
  final bool writeOffButton;
  final bool selectionButton;
  final bool admissionButton;
  final bool routes;
  final bool movingButton;
  final bool returningButton;
  final bool rechargeButton;
  final bool cameraScaner;
  final bool basketOperation;
  final bool npTtnPrintButton;
  final bool meestTtnPrintButton;
  final bool labelPrintButton;
  final bool movingDefectiveButton;
  final bool epicenterButton;

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
      this.npTtnPrintButton = false,
      this.meestTtnPrintButton = false,
      this.labelPrintButton = false,
      this.movingDefectiveButton = false,
      this.epicenterButton = false,
      this.generationButton = false,
      this.printButton = false,
      this.soundDif = false,
      this.taskNumber = false,
      this.cellInfoButton = false,
      this.basketInfoButton = false,
      this.cellGeneratorButton = false,
      this.placementButton = false,
      this.writeOffButton = false,
      this.selectionButton = false,
      this.admissionButton = false,
      this.routes = false,
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
      bool? npTtnPrintButton,
      bool? meestTtnPrintButton,
      bool? labelPrintButton,
      bool? movingDefectiveButton,
      bool? epicenterButton,
      bool? generationButton,
      bool? printButton,
      bool? soundDif,
      bool? taskNumber,
      bool? cellInfoButton,
      bool? basketInfoButton,
      bool? cellGeneratorButton,
      bool? placementButton,
      bool? writeOffButton,
      bool? selectionButton,
      bool? admissionButton,
      bool? routes,
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
        npTtnPrintButton: npTtnPrintButton ?? this.npTtnPrintButton,
        meestTtnPrintButton: meestTtnPrintButton ?? this.meestTtnPrintButton,
        labelPrintButton: labelPrintButton ?? this.labelPrintButton,
        epicenterButton: epicenterButton ?? this.epicenterButton,
        movingDefectiveButton:
            movingDefectiveButton ?? this.movingDefectiveButton,
        generationButton: generationButton ?? this.generationButton,
        printButton: printButton ?? this.printButton,
        soundDif: soundDif ?? this.soundDif,
        taskNumber: taskNumber ?? this.taskNumber,
        cellInfoButton: cellInfoButton ?? this.cellInfoButton,
        basketInfoButton: basketInfoButton ?? this.basketInfoButton,
        cellGeneratorButton: cellGeneratorButton ?? this.cellGeneratorButton,
        placementButton: placementButton ?? this.placementButton,
        writeOffButton: writeOffButton ?? this.writeOffButton,
        selectionButton: selectionButton ?? this.selectionButton,
        admissionButton: admissionButton ?? this.admissionButton,
        routes: routes ?? this.routes,
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
        npTtnPrintButton,
        meestTtnPrintButton,
        labelPrintButton,
        movingDefectiveButton,
        epicenterButton,
        generationButton,
        printButton,
        soundDif,
        taskNumber,
        printerHost,
        printerPort,
        cellInfoButton,
        cellGeneratorButton,
        placementButton,
        writeOffButton,
        basketInfoButton,
        selectionButton,
        admissionButton,
        routes,
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
