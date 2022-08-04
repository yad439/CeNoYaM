import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/search_results.dart';

part 'search_state.freezed.dart';

@immutable
@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.found(SearchResults results) = _Found;
}
