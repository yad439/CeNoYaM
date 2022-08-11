import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/enum/search_type.dart';
import '../../domain/music_repository.dart';
import 'loading_state.dart';

class SearchResultsBloc extends Bloc<String, SearchState> {
  SearchResultsBloc(this._repository)
      : super(const SearchState.uninitialized()) {
    on<String>(_search);
  }

  final MusicRepository _repository;

  Future<void> _search(String query, Emitter<SearchState> emit) async {
    emit(
      SearchState.loaded(
        await _repository.search(query, SearchType.all),
      ),
    );
  }
}
