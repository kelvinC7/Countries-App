import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class CacheConfig {
  // Global options typically defined once; store is required here
  static final _defaultCacheOptions = CacheOptions(
    store: MemCacheStore(), // Or FileCacheStore, HiveCacheStore, etc.
    policy: CachePolicy.request,
    maxStale: const Duration(days: 7), // Equivalent to your maxStale
  );

  // Standard cache options
  static Options cacheOptions = _defaultCacheOptions.copyWith(
    policy: CachePolicy.forceCache, // Use cache if available, else network
  ).toOptions();
  
  // Force refresh options
  static Options forceRefreshCacheOptions = _defaultCacheOptions.copyWith(
    policy: CachePolicy.refreshForceCache, // Force network request and update cache
  ).toOptions();
}
