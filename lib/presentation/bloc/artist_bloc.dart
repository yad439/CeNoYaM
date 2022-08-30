import '../../domain/entity/album.dart';
import 'loading_bloc.dart';

class ArtistBloc extends LoadingBloc<int, List<AlbumMin>> {
  ArtistBloc(super.repository);

  @override
  Future<List<AlbumMin>> fetch(int event) =>
      repository.getArtist(event).then((value) => value.albums);
}
