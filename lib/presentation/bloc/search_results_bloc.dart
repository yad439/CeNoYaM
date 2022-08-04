import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/music_repository.dart';
import '../../domain/search_type.dart';
import 'search_state.dart';

class SearchResultsBloc extends Bloc<String, SearchState> {
  SearchResultsBloc(this._repository) : super(const SearchState.initial()) {
    on<String>(_search);
  }

  final MusicRepository _repository;

  Future<void> _search(String query, Emitter<SearchState> emit) async {
    emit(SearchState.found(
        await _repository.search(query, SearchType.playlists)));
  }
}
