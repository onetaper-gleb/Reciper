import 'package:equatable/equatable.dart';

class RecipeEvent extends Equatable {
  const RecipeEvent();
  @override
  List<Object?> get props => [];
}

class RecipeSearchRequested extends RecipeEvent {
  const RecipeSearchRequested({
    required this.query,
    required this.filters,
  });
  final String query;
  final Map<String, dynamic> filters;

  @override
  List<Object?> get props => [query, filters];
}

class RecipeSuggestFromFridge extends RecipeEvent {
  const RecipeSuggestFromFridge({
    this.queryHint = '',
    this.filters = const {},
  });
  final String queryHint;
  final Map<String, dynamic> filters;

  @override
  List<Object?> get props => [queryHint, filters];
}

class RecipeFavoritesRequested extends RecipeEvent {
  const RecipeFavoritesRequested();
}

class RecipeFavoriteToggled extends RecipeEvent {
  const RecipeFavoriteToggled(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}
