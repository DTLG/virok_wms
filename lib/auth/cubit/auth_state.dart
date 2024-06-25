part of 'auth_cubit.dart';

enum AuthStatus { initial, login, unknown, failure, loading, succsses }

extension AuthStatusX on AuthStatus {
  bool get isLogin => this == AuthStatus.login;
  bool get isLoading => this == AuthStatus.loading;
  bool get isUnknown => this == AuthStatus.unknown;
  bool get isFailure => this == AuthStatus.failure;
  bool get isSaccsses => this == AuthStatus.succsses;
  bool get isInitial => this == AuthStatus.initial;
}

final class AuthState extends Equatable {
  AuthState(
      {this.status = AuthStatus.initial,
      this.zone = '',
      this.user = '',
      this.dbPath = '',
      UsersAndZones? zones,
      this.time = 0,
      this.userPass = '',
      this.errorMassage = '',
      this.deviceId = ''})
      : usersAndZones = zones ?? UsersAndZones.empty;


  final AuthStatus status;
  final String zone;
  final String user;
  final UsersAndZones usersAndZones;

  final int time;
  final String dbPath;
  final String deviceId;
  final String userPass;
  final String errorMassage;

  AuthState copyWith(
      {AuthStatus? status,
      String? zone,
      String? user,
      UsersAndZones? usersAndZones,
      int? time,
      String? userPass,
      String? dbPath,
      String? errorMassage,
      String? deviceId,
}) {
    return AuthState(
        status: status ?? this.status,
        zone: zone ?? this.zone,
        user: user ?? this.user,
        dbPath: dbPath ?? this.dbPath,
        zones: usersAndZones ?? this.usersAndZones,
        userPass: userPass ?? this.userPass,
        time: time ?? this.time,
        deviceId: deviceId ?? this.deviceId,

        errorMassage: errorMassage ?? this.errorMassage,
);
  }

  @override
  List<Object?> get props => [
        status,
        zone,
        user,
        usersAndZones,
        time,
        dbPath,
        deviceId,
        userPass,
        errorMassage,
      ];
}
