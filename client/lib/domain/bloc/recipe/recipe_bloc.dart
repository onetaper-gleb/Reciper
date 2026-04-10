import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client/core/errors/user_facing_error.dart';
import '../../../data/repository/recipe_repository.dart';
import '../../models/recipe.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

typedef FridgeProductsLoader = Future<List<Map<String, dynamic>>> Function();

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc({
    required RecipeRepositoryBase repository,
    FridgeProductsLoader? fridgeProductsLoader,
  })  : _repo = repository,
        _fridgeProductsLoader =
            fridgeProductsLoader ?? (() async => const <Map<String, dynamic>>[]),
        super(const RecipeInitial()) {
    on<RecipeSearchRequested>(_onSearch);
    on<RecipeSuggestFromFridge>(_onFromFridge);
    on<RecipeFavoritesRequested>(_onFavorites);
    on<RecipeFavoriteToggled>(_onToggleFavorite);
    on<RecipeCatalogSyncRequested>(_onCatalogSync);
  }

  final RecipeRepositoryBase _repo;
  final FridgeProductsLoader _fridgeProductsLoader;
  List<Recipe> _lastResults = const [];

  Future<void> _onSearch(
    RecipeSearchRequested event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    try {
      final recipes = await _repo.suggestRecipes(
        query: event.query,
        filters: event.filters,
        fridgeProducts: const [],
      );
      _lastResults = recipes;
      emit(RecipeResults(recipes));
    } catch (e) {
      emit(RecipeError(userFacingErrorMessage(e)));
    }
  }

  Future<void> _onFromFridge(
    RecipeSuggestFromFridge event,
    Emitter<RecipeState> emit,
  ) async {
    emit(const RecipeLoading());
    try {
      final fridgeProducts = await _fridgeProductsLoader();
      final fridgeNames = fridgeProducts
          .map((e) => e['name']?.toString().trim())
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .take(8)
          .join(', ');
      final query = event.queryHint.trim().isNotEmpty
          ? event.queryHint.trim()
          : 'Подбери блюда из: $fridgeNames';
      final recipes = await _repo.suggestRecipes(
        query: query,
        filters: {
          'from_fridge': true,
          ...event.filters,
        },
        fridgeProducts: fridgeProducts,
      );
      _lastResults = recipes;
      emit(RecipeResults(recipes));
    } catch (e) {
      emit(RecipeError(userFacingErrorMessage(e)));
    }
  }

  Future<void> _onFavorites(
    RecipeFavoritesRequested event,
    Emitter<RecipeState> emit,
  ) async {
    final favorites = await _repo.getFavorites();
    emit(RecipeFavorites(favorites));
  }

  Future<void> _onToggleFavorite(
    RecipeFavoriteToggled event,
    Emitter<RecipeState> emit,
  ) async {
    await _repo.toggleFavorite(event.id);
    if (state is RecipeResults) {
      final refreshed = <Recipe>[];
      for (final item in _lastResults) {
        final id = item.id;
        final fromDb = await _repo.getRecipeById(id);
        refreshed.add(fromDb ?? item);
      }
      _lastResults = refreshed;
      emit(RecipeResults(refreshed));
      return;
    }
    if (state is RecipeFavorites) {
      final favorites = await _repo.getFavorites();
      emit(RecipeFavorites(favorites));
    }
  }

  Future<void> _onCatalogSync(
    RecipeCatalogSyncRequested event,
    Emitter<RecipeState> emit,
  ) async {
    if (state is RecipeResults) {
      final refreshed = <Recipe>[];
      for (final item in _lastResults) {
        refreshed.add((await _repo.getRecipeById(item.id)) ?? item);
      }
      _lastResults = refreshed;
      emit(RecipeResults(refreshed));
      return;
    }
    if (state is RecipeFavorites) {
      final favorites = await _repo.getFavorites();
      emit(RecipeFavorites(favorites));
    }
  }
}
