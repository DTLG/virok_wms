part of 'login_cubit.dart';

enum LoginStatus { initial, login, unknown, failure, loading }

extension LoginStatusX on LoginStatus {
  bool get isLogin => this == LoginStatus.login;
  bool get isLoading => this == LoginStatus.loading;
  bool get isUnknown => this == LoginStatus.unknown;
  bool get isFailure => this == LoginStatus.failure;
}

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
  });

  final LoginStatus status;

  LoginState copyWith({LoginStatus? status}) {
    return LoginState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
