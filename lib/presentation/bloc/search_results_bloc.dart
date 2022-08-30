import '../../domain/entity/search_results.dart';
import '../../domain/enum/search_type.dart';
import 'loading_bloc.dart';
import 'loading_state.dart';

typedef SearchState = LoadingState<SearchResults>;

class SearchResultsBloc extends LoadingBloc<String, SearchResults> {
  SearchResultsBloc(super.repository);

  @override
  Future<SearchResults> fetch(String event) =>
      repository.search(event, SearchType.all);
}
