part of 'home_controller.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoadingFromCache extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final List<CountrySummary> countries;
  final Set<String> favorites;
  final bool isFromCache;

  const HomeLoaded({
    required this.countries,
    required this.favorites,
    this.isFromCache = false,
  });

  bool isFavorite(String countryCode) => favorites.contains(countryCode);

  @override
  List<Object> get props => [countries, favorites, isFromCache];
}

class HomeError extends HomeState {
  final String error;
  final VoidCallback? onRetry;
  final bool isCacheError;

  const HomeError({
    required this.error,
    this.onRetry,
    this.isCacheError = false,
  });

  @override
  List<Object> get props => [error, isCacheError];
}