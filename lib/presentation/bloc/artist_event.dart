import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enum/artist_subcategory.dart';

part 'artist_event.freezed.dart';

@freezed
class ArtistEvent with _$ArtistEvent {
  const factory ArtistEvent(int id, ArtistSubcategory? subcategory) =
      _ArtistEvent;
}
