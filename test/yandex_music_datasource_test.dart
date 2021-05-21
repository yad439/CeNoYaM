import 'package:cenoyam/data/yandex_music_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final datasource = YandexMusicDatasource();

  test('should return correct track info', () async {
    final trackInfo = await datasource.getTrackInfo(5493020);
    final track = trackInfo.track;

    expect(track.title, 'Still Alive');
    expect(track.albums.length, 1);
    expect(track.albums[0].id, 605103);
    expect(track.albums[0].title, 'Portal 2: Songs to Test By');
    expect(track.artists.length, 1);
    expect(track.artists[0].id, 1716328);
    expect(
        track.artists[0].name, 'Aperture Science Psychoacoustic Laboratories');
  });

  test('should return correct album', () async {
    final album = await datasource.getAlbum(605103);

    expect(album.title, 'Portal 2: Songs to Test By');
    expect(album.artists.length, 1);
    expect(album.artists[0].id, 1716328);
    expect(
        album.artists[0].name, 'Aperture Science Psychoacoustic Laboratories');
    expect(album.volumes.length, 4);
    expect(album.volumes[0][0].id, '5493089');
  });

  test("should return correct playlist", () async {
    final playlistBox =
        await datasource.getPlaylist('yamusic-bestsongs', 222057);
    final playlist = playlistBox.playlist;

    expect(playlist.title, 'Лучшее: Epica');
    expect(playlist.tracks.length, 20);
    expect(playlist.tracks[0].id, '1361730');
  });

  test("should return correct artist", () async {
    final artistInfo = await datasource.getArtist(1716328);
    final artist = artistInfo.artist;

    expect(artist.name, 'Aperture Science Psychoacoustic Laboratories');
    expect(artistInfo.albums.length, 1);
    expect(artistInfo.albums[0].title, 'Portal 2: Songs to Test By');
    expect(artistInfo.trackIds.length, 76);
  });
}
