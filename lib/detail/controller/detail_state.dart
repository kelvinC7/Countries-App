part of 'detail_controller.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoadingFromCache extends DetailState {
  @override
  List<Object> get props => [];
}

class DetailLoaded extends DetailState {
  final CountryDetails details;
  final bool isFromCache;

  const DetailLoaded({
    required this.details,
    this.isFromCache = false,
  });

  @override
  List<Object> get props => [details, isFromCache];
}

class DetailError extends DetailState {
  final String error;
  final bool isCacheError;

  const DetailError({
    required this.error,
    this.isCacheError = false,
  });

  @override
  List<Object> get props => [error, isCacheError];
}