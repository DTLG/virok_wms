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

  final String printerHost;
  final String printerPort;

  const SettingsState(
      {this.status = SettingsStatus.initial,
      this.dbPath = '',
      this.generationButton = false,
      this.printButton = false,
      this.cellInfoButton = false,
      this.printerHost = '',
      this.printerPort = ''});

  SettingsState copyWith(
      {SettingsStatus? status,
      String? dbPath,
      bool? generationButton,
      bool? printButton,
      bool? cellInfoButton,
      String? printerHost,
      String? printerPort}) {
    return SettingsState(
        status: status ?? this.status,
        dbPath: dbPath ?? this.dbPath,
        generationButton: generationButton ?? this.generationButton,
        printButton: printButton ?? this.printButton,
        cellInfoButton: cellInfoButton ?? this.cellInfoButton,
        printerHost: printerHost ?? this.printerHost,
        printerPort: printerPort ?? this.printerPort);
  }

  @override
  List<Object?> get props => [
        status,
        dbPath,
        generationButton,
        printButton,
        printerHost,
        printerPort,
        cellInfoButton
      ];
}
