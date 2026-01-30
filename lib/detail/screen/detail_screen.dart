import 'package:countries/common/widgets/network_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../data/local_storage.dart';
import '../controller/detail_controller.dart';
import '../domain/model/country_details.dart';
import '../domain/repository/detail_repo.dart';
import '../widget/detail_shimmer.dart';


class CountryDetailScreen extends StatelessWidget {
  final String countryCode;

  const CountryDetailScreen({super.key, required this.countryCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailController(
        repository: Get.find<DetailRepository>(),
        countryCode: countryCode,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          actions: [
            BlocBuilder<DetailController, DetailState>(
              builder: (context, state) {
                if (state is DetailLoaded && state.isFromCache) {
                  return IconButton(
                    icon: const Icon(Icons.cached, size: 20),
                    tooltip: 'Loaded from cache',
                    onPressed: null,
                  );
                }
                return const SizedBox();
              },
            ),
            BlocBuilder<DetailController, DetailState>(
              builder: (context, state) {
                return PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          const Icon(Icons.refresh, size: 20),
                          const SizedBox(width: 8),
                          const Text('Refresh'),
                          if (state is DetailLoaded && state.isFromCache)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(Icons.cached, size: 14, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'clear_cache',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 20),
                          const SizedBox(width: 8),
                          const Text('Clear Cache'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    final controller = context.read<DetailController>();
                    if (value == 'refresh') {
                      controller.refresh();
                    } else if (value == 'clear_cache') {
                      // Implement cache clearing
                      _clearCacheForCountry(context, countryCode);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DetailController, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading || state is DetailLoadingFromCache) {
              return Stack(
                children: [
                  const CountryDetailShimmer(),
                  if (state is DetailLoadingFromCache)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.cached, size: 14, color: Colors.blue),
                            const SizedBox(width: 6),
                            Text(
                              'Cache',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            } else if (state is DetailError) {
              return _buildErrorState(context, state);
            } else if (state is DetailLoaded) {
              return Column(
                children: [
                  if (state.isFromCache)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.blue[50],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cached, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Loaded from cache',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () => context.read<DetailController>().refresh(),
                            child: Text(
                              'Refresh',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: CountryDetailView(details: state.details),
                  ),
                ],
              );
            }
            return const CountryDetailShimmer();
          },
        ),
      ),
    );
  }

  void _clearCacheForCountry(BuildContext context, String countryCode) async {
    final localStorage = Get.find<LocalStorage>();
    await localStorage.clearCountryDetailsCache(countryCode);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cleared cache for country'),
        action: SnackBarAction(
          label: 'Refresh',
          onPressed: () => context.read<DetailController>().refresh(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, DetailError state) {
    return NetworkErrorWidget(onRetry: () => context.read<DetailController>().retry());
  }
}

// ... rest of your CountryDetailView remains the same

class CountryDetailView extends StatelessWidget {
  final CountryDetails details;

  const CountryDetailView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero animation for flag
   Hero(
  tag: 'country-flag-${details.name}', // Make sure this matches
  child: Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: NetworkImage(details.flag),
        fit: BoxFit.cover,
      ),
    ),
  ),
),
          const SizedBox(height: 24),
          
          // Country Name
          Text(
            details.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Key Statistics Section
          const Text(
            'Key Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _StatCard(
                title: 'Area',
                value: details.formattedArea,
                icon: Icons.terrain,
              ),
              _StatCard(
                title: 'Population',
                value: details.population.toString(),
                icon: Icons.people,
              ),
              _StatCard(
                title: 'Region',
                value: details.region,
                icon: Icons.public,
              ),
              _StatCard(
                title: 'Subregion',
                value: details.subregion,
                icon: Icons.location_on,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Capital City
          _DetailRow(
            icon: Icons.location_city,
            title: 'Capital',
            value: details.capital,
          ),
          
          const SizedBox(height: 16),
          
          // Timezones Section
          const Text(
            'Timezones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: details.timezones.map((timezone) {
              return Chip(
                label: Text(timezone),
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}