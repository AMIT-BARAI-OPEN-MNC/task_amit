import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_amit/core/services/navigationServices.dart';
import 'package:task_amit/core/uttils/colors.dart';
import 'package:task_amit/data/search_model.dart';
import 'package:task_amit/logic/favorit_bloc.dart';
import 'package:task_amit/router/pageName.dart';

class favoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Posts")),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoritesLoaded) {
            return ListView.builder(
              itemCount: state.favoritePosts.length,
              itemBuilder: (context, index) {
                Post post = state.favoritePosts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<FavoriteBloc>().add(ToggleFavorite(post));
                    },
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
