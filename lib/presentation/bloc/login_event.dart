import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.freezed.dart';

@freezed
class LoginFormEvent with _$LoginFormEvent {
  const factory LoginFormEvent.login() = TryLogin;
  const factory LoginFormEvent.saveLogin(String login) = SaveLogin;
  const factory LoginFormEvent.savePassword(String password) = SavePassword;
  const factory LoginFormEvent.clearState() = ClearState;
}
