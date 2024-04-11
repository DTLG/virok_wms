part of 'login_cubit.dart';

enum LoginStatus { initial, login, unknown, failure, loading, succsses, a }

extension LoginStatusX on LoginStatus {
  bool get isLogin => this == LoginStatus.login;
  bool get isLoading => this == LoginStatus.loading;
  bool get isUnknown => this == LoginStatus.unknown;
  bool get isFailure => this == LoginStatus.failure;
  bool get isSaccsses => this == LoginStatus.succsses;
    bool get isInitial => this == LoginStatus.initial;
        bool get a => this == LoginStatus.a;

    

}

final class LoginState extends Equatable {
  const LoginState(
      {this.status = LoginStatus.initial,
      this.zone = '',
      this.dbPath = '',
      Users? users,
      this.time = 0})
      : users = users ?? Users.empty;

  final LoginStatus status;
  final String zone;
  final Users users;
  final int time;
  final String dbPath;

  LoginState copyWith(
      {LoginStatus? status, String? zone, Users? users, int? time, String? dbPath}) {
    return LoginState(
        status: status ?? this.status,
        zone: zone ?? this.zone,
        dbPath: dbPath ?? this.dbPath,
        users: users ?? this.users,
        time: time ?? this.time);
  }

  @override
  List<Object?> get props => [status, zone, users, time,dbPath];
}
