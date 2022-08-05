import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/music_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginBloc(this._repository)
      : super(const LoginFormState(LoginState.initial, '', '')) {
    on<TryLogin>(_login, transformer: sequential());
    on<SaveLogin>(_saveLogin);
    on<SavePassword>(_savePassword);
    on<ClearState>(_clearState);
  }
  final MusicRepository _repository;

  Future<void> _login(TryLogin event, Emitter<LoginFormState> emit) async {
    if (await _repository.login(state.login, state.password)) {
      emit(state.copyWith(state: LoginState.success));
    } else {
      emit(state.copyWith(state: LoginState.failure));
    }
  }

  void _saveLogin(SaveLogin event, Emitter<LoginFormState> emit) {
    emit(state.copyWith(login: event.login));
  }

  void _savePassword(SavePassword event, Emitter<LoginFormState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _clearState(ClearState event, Emitter<LoginFormState> emit) {
    emit(state.copyWith(state: LoginState.initial));
  }
}
