import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/presentation/bloc/login_bloc.dart';
import 'package:cenoyam/presentation/bloc/login_event.dart';
import 'package:cenoyam/presentation/bloc/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<MusicRepository>()])
import 'login_bloc_test.mocks.dart';

void main() {
  MockMusicRepository? repository;
  LoginBloc? bloc;
  setUp(() {
    repository = MockMusicRepository();
    bloc = LoginBloc(repository!);
  });
  tearDown(() {
    bloc?.close();
    bloc = null;
    repository = null;
  });

  test('On init, state is initial', () {
    expect(bloc!.state.state, LoginState.initial);
  });

  test('When login saved, should emit state with login', () {
    bloc!.add(const LoginFormEvent.saveLogin('login'));

    expect(
      // ignore: avoid_types_on_closure_parameters
      bloc!.stream, emits((LoginFormState state) => state.login == 'login'),
    );
  });

  test('When password saved, should emit state with password', () {
    bloc!.add(const LoginFormEvent.savePassword('pass'));

    expect(
      bloc!.stream,
      // ignore: avoid_types_on_closure_parameters
      emits((LoginFormState state) => state.password == 'pass'),
    );
  });

  test('On successive save and login should try correct login and password',
      () async {
    bloc!.add(const LoginFormEvent.saveLogin('login'));
    bloc!.add(const LoginFormEvent.savePassword('pass'));
    bloc!.add(const LoginFormEvent.login());

    await expectLater(
      bloc!.stream,
      emitsThrough(
        // ignore: avoid_types_on_closure_parameters
        (LoginFormState state) => state.state != LoginState.initial,
      ),
    );
    verify(repository!.login('login', 'pass'));
  });

  test('On login, if succeed, should emit state with logged in', () {
    when(repository!.login(any, any)).thenAnswer((_) async => true);

    bloc!.add(const LoginFormEvent.login());

    expect(
      bloc!.stream,
      // ignore: avoid_types_on_closure_parameters
      emits((LoginFormState state) => state.state == LoginState.success),
    );
  });

  test('On login, if failed, should emit state with failure', () {
    when(repository!.login(any, any)).thenAnswer((_) async => false);

    bloc!.add(const LoginFormEvent.login());

    expect(
      bloc!.stream,
      // ignore: avoid_types_on_closure_parameters
      emits((LoginFormState state) => state.state == LoginState.failure),
    );
  });
}
