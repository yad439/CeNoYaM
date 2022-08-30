import '../../domain/entity/artist.dart';
import 'loading_bloc.dart';
import 'loading_state.dart';

typedef ArtistState = LoadingState<Artist>;

class ArtistBloc extends LoadingBloc<int, Artist> {
  ArtistBloc(super.repository);

  @override
  Future<Artist> fetch(int event) => repository.getArtist(event);
}
