import '../../domain/entity/artist.dart';
import 'artist_event.dart';
import 'loading_bloc.dart';
import 'loading_state.dart';

typedef ArtistState = LoadingState<Artist>;

class ArtistBloc extends LoadingBloc<ArtistEvent, Artist> {
  ArtistBloc(super.repository);

  @override
  Future<Artist> fetch(ArtistEvent event) =>
      repository.getArtist(event.id, subcategory: event.subcategory);
}
