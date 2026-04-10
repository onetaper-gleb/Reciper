import 'package:equatable/equatable.dart';

import '../../models/recipe.dart';

class RecipeState extends Equatable {
  const RecipeState();
  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {
  const RecipeInitial();
}

class RecipeLoading extends RecipeState {
  const RecipeLoading();
}

class RecipeResults extends RecipeState {
  const RecipeResults(this.recipes);
  final List<Recipe> recipes;

  @override
  List<Object?> get props => [recipes];
}

class RecipeFavorites extends RecipeState {
  const RecipeFavorites(this.recipes);
  final List<Recipe> recipes;

  @override
  List<Object?> get props => [recipes];
}

class RecipeError extends RecipeState {
  const RecipeError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
