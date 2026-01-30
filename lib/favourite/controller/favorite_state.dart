part of 'favorite_controller.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<CountrySummary> favorites;

  const FavoritesLoaded({required this.favorites});

  @override
  List<Object> get props => [favorites];
}

class FavoritesEmpty extends FavoritesState {
  final String message;

  const FavoritesEmpty({
    this.message = 'No favorite countries yet',
  });

  @override
  List<Object> get props => [message];
}

class FavoritesError extends FavoritesState {
  final String error;
  final VoidCallback? onRetry;

  const FavoritesError({
    required this.error,
    this.onRetry,
  });

  @override
  List<Object> get props => [error];
}

// New state for when a favorite is being removed
class FavoriteRemoving extends FavoritesState {
  final String countryCode;
  final List<CountrySummary> currentFavorites;

  const FavoriteRemoving({
    required this.countryCode,
    required this.currentFavorites,
  });

  @override
  List<Object> get props => [countryCode, currentFavorites];
}