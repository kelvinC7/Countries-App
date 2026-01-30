import 'package:bloc/bloc.dart';
import 'package:countries/detail/domain/model/country_details.dart';
import 'package:countries/detail/domain/repository/detail_repo.dart';
import 'package:equatable/equatable.dart';

part 'detail_state.dart';

class DetailController extends Cubit<DetailState> {
  final DetailRepository repository;
  final String countryCode;
  
  bool _isLoadingFromCache = false;

  DetailController({
    required this.repository,
    required this.countryCode,
  }) : super(DetailInitial()) {
    _loadCountryDetailsWithCache();
  }

  Future<void> _loadCountryDetailsWithCache() async {
    emit(DetailLoadingFromCache());
    _isLoadingFromCache = true;
    
    try {
      // Try to load from cache first (instant)
      final details = await repository.getCountryDetails(countryCode);
      
      emit(DetailLoaded(
        details: details,
        isFromCache: _isLoadingFromCache,
      ));
      
      // If we loaded from cache, refresh from API in background
      if (_isLoadingFromCache) {
        _refreshFromApi();
      }
    } catch (e) {
     
      // If cache fails, load from API
      await _loadFromApi();
    }
  }

  Future<void> _loadFromApi() async {
    emit(DetailLoading());
    _isLoadingFromCache = false;
    
    try {
      final details = await repository.getCountryDetails(countryCode);
      emit(DetailLoaded(
        details: details,
        isFromCache: false,
      ));
    } catch (e) {
      emit(DetailError(error: e.toString()));
    }
  }

  Future<void> _refreshFromApi() async {
    try {
      await repository.getCountryDetails(countryCode);
   
    } catch (e) {
    return;
    }
  }

  Future<void> loadCountryDetails({bool forceRefresh = false}) async {
    if (forceRefresh) {
      await _loadFromApi();
    } else {
      await _loadCountryDetailsWithCache();
    }
  }

  void retry() {
    loadCountryDetails();
  }

  // Force refresh from API
  Future<void> refresh() async {
    await _loadFromApi();
  }

  bool get isLoadingFromCache => _isLoadingFromCache;
}