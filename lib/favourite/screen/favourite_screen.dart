import 'package:cached_network_image/cached_network_image.dart';
import 'package:countries/common/widgets/network_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../data/local_storage.dart';
import '../../home/domain/model/country_summary.dart';
import '../../helper/route_helper.dart';
import '../../home/domain/repository/home_repo.dart';
import '../../theme/widget/theme_toggle_button.dart';
import '../../utils/color_resources.dart';
import '../controller/favorite_controller.dart';
import '../widget/favorite_country_item.dart';
import '../widget/favorite_shimmer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesController(
        localStorage: Get.find<LocalStorage>(), // Use Get.find
        repository: Get.find<HomeRepository>(), // Use Get.find
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          centerTitle: true,
          actions: const [
            ThemeToggleButton(), // Add theme toggle button
          ],
        ),
        body: BlocBuilder<FavoritesController, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const FavoritesShimmerList();
            } else if (state is FavoritesError) {
              return NetworkErrorWidget(
                  onRetry: () =>
                      context.read<FavoritesController>().loadFavorites());
            } else if (state is FavoritesEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border,
                        size: 80, color: Colors.grey),
                    const SizedBox(height: 24),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        'Tap the heart icon on any country in the Home screen to add it here',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.home),
                      label: const Text('Go to Home'),
                      onPressed: () => Get.offAllNamed(RouteHelper.main),
                    ),
                  ],
                ),
              );
            } else if (state is FavoritesLoaded) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<FavoritesController>().loadFavorites(),
                child: ListView.builder(
                  itemCount: state.favorites.length,
                  itemBuilder: (context, index) {
                    final country = state.favorites[index];
                    return FavoriteCountryItem(country: country);
                  },
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

