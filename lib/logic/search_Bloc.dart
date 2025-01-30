import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:task_amit/data/search_model.dart';

abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchFieldFocused extends SearchEvent {}

class SearchFieldUnfocused extends SearchEvent {}

abstract class SearchState extends Equatable {
  final bool isSearching;

  const SearchState({this.isSearching = false});

  @override
  List<Object?> get props => [isSearching];
}

class SearchInitial extends SearchState {
  const SearchInitial({bool isSearching = false})
      : super(isSearching: isSearching);
}

class SearchLoading extends SearchState {
  const SearchLoading({bool isSearching = false})
      : super(isSearching: isSearching);
}

class SearchLoaded extends SearchState {
  final SearchResponse searchResponse;

  const SearchLoaded(this.searchResponse, {bool isSearching = false})
      : super(isSearching: isSearching);

  @override
  List<Object?> get props => [searchResponse, isSearching];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message, {bool isSearching = false})
      : super(isSearching: isSearching);

  @override
  List<Object?> get props => [message, isSearching];
}

// Bloc Class
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Dio _dio = Dio();
  Timer? _debounce;

  SearchBloc() : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchFieldFocused>(
        (event, emit) => emit(const SearchInitial(isSearching: true)));
    on<SearchFieldUnfocused>(
        (event, emit) => emit(const SearchInitial(isSearching: false)));
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial(isSearching: true));
      return;
    }

    // Cancel any ongoing debounce timer
    _debounce?.cancel();

    // Start a new debounce logic
    _debounce = Timer(const Duration(milliseconds: 500), () {});

    await Future.delayed(const Duration(milliseconds: 500)); // Debounce

    try {
      emit(const SearchLoading(isSearching: true)); // Show loading indicator

      print("Making API call for query: ${event.query}");
      final response =
          await _dio.get("https://dummyjson.com/posts/search?q=${event.query}");
      final searchResponse = SearchResponse.fromJson(response.data);

      print("✅ API Response: ${response.data}"); // Debugging

      if (!emit.isDone) {
        emit(SearchLoaded(searchResponse, isSearching: true));
      }
    } catch (e) {
      print("❌ API Error: $e"); // Debugging

      if (!emit.isDone) {
        emit(const SearchError("Failed to load search results",
            isSearching: true));
      }
    }
  }
}
