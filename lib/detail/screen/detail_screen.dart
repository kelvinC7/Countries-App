import 'package:countries/common/widgets/network_error.dart';
import 'package:countries/detail/widget/statistic_widget.dart';
import 'package:countries/utils/color_resources.dart';
import 'package:countries/utils/style.dart';
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
          title: BlocBuilder<DetailController, DetailState>(
            builder: (context, state) {
              if (state is DetailLoaded) {
                return Text(state.details.name);
              }
              return const Text('Loading...'); // Or empty Text
            },
          ),
        ),
        body: BlocBuilder<DetailController, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading || state is DetailLoadingFromCache) {
              return const CountryDetailShimmer();
            } else if (state is DetailError) {
              return _buildErrorState(context, state);
            } else if (state is DetailLoaded) {
              return CountryDetailView(details: state.details);
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
    return NetworkErrorWidget(
        onRetry: () => context.read<DetailController>().retry());
  }
}

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
            tag: 'country-flag-${details.name}',
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
            crossAxisCount: 1,
            childAspectRatio: 6.0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 12,
            children: [
              StatisticWidget(
                title: 'Area',
                value: details.formattedArea,
              ),
              StatisticWidget(
                title: 'Population',
                value: details.population.toString(),
              ),
              StatisticWidget(
                title: 'Region',
                value: details.region,
              ),
              StatisticWidget(
                title: 'Subregion',
                value: details.subregion,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Capital City
          // _DetailRow(
          //   icon: Icons.location_city,
          //   title: 'Capital',
          //   value: details.capital,
          // ),

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

               
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}



