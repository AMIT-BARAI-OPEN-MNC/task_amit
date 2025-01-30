import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/data/search_model.dart';
import 'package:task_amit/data/local_db/hive_db.dart';

abstract class FavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<Post> favoritePosts;
  FavoritesLoaded(this.favoritePosts);

  @override
  List<Object> get props => [favoritePosts];
}

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final Post post;
  ToggleFavorite(this.post);

  @override
  List<Object> get props => [post];
}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<LoadFavorites>((event, emit) {
      final savedPosts = HiveStorage.getSavedPosts();
      emit(FavoritesLoaded(savedPosts));
    });

    on<ToggleFavorite>((event, emit) async {
      if (HiveStorage.isPostSaved(event.post.id)) {
        await HiveStorage.removePost(event.post.id);
      } else {
        await HiveStorage.savePost(event.post);
      }
      final updatedPosts = HiveStorage.getSavedPosts();
      emit(FavoritesLoaded(updatedPosts));
    });
  }
}
