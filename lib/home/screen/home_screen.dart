import 'package:countries/common/widgets/network_error.dart';
import 'package:countries/home/controller/home_controller.dart';
import 'package:countries/home/widget/search_bar.dart';
import 'package:countries/home/widget/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../data/api_client.dart';
import '../../data/local_storage.dart';
import '../domain/repository/home_repo.dart';
import '../widget/country_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeController(
        repository: HomeRepository(
          apiClient: ApiClient(
              client: Get.find(), localStorage: Get.find<LocalStorage>()),
        ),
        localStorage: Get.find<LocalStorage>(),
      )..loadCountries(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        centerTitle: true,
      
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SearchBarWidget(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context
                    .read<HomeController>()
                    .loadCountries(forceRefresh: true);
              },
              child: BlocBuilder<HomeController, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const CountryShimmerList();
                  } else if (state is HomeError) {
                    return NetworkErrorWidget(
                    
                      onRetry: () =>
                          context.read<HomeController>().loadCountries(),
                    );
                  } else if (state is HomeLoaded) {
                    if (state.countries.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No countries found',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<HomeController>().loadCountries(),
                      child: ListView.builder(
                        itemCount: state.countries.length,
                        itemBuilder: (context, index) {
                          final country = state.countries[index];
                          return CountryListItem(country: country);
                        },
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
