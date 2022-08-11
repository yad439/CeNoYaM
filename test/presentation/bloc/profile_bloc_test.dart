import 'package:cenoyam/domain/music_repository.dart';
import 'package:cenoyam/presentation/bloc/profile_bloc.dart';
import 'package:cenoyam/presentation/bloc/profile_event.dart';
import 'package:cenoyam/presentation/bloc/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([MusicRepository])
import 'profile_bloc_test.mocks.dart';

void main() {
  MusicRepository? repository;
  ProfileBloc? bloc;

  setUp(() {
    repository = MockMusicRepository();
    bloc = ProfileBloc(repository!);
  });
  tearDown(() {
    bloc?.close();
    bloc = null;
    repository = null;
  });

  test('On init, state is unknown', () {
    expect(bloc!.state, const ProfileState.unknown());
  });

  test('On update, if succeed, state is logged in', () {
    when(repository!.getUsername()).thenAnswer((_) async => 'username');

    bloc!.add(ProfileEvent.update);

    expect(bloc!.stream, emits(isLoggedIn));
  });

  test('On update, if failed, state is anonimous', () {
    when(repository!.getUsername()).thenAnswer((_) async => null);

    bloc!.add(ProfileEvent.update);

    expect(bloc!.stream, emits(isAnonimous));
  });
}

bool isLoggedIn(ProfileState state) =>
    state.maybeMap(loggedIn: (_) => true, orElse: () => false);
bool isAnonimous(ProfileState state) =>
    state.maybeMap(anonimous: (_) => true, orElse: () => false);
