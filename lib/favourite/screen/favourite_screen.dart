import 'package:cached_network_image/cached_network_image.dart';
import 'package:countries/common/widgets/network_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../data/local_storage.dart';
import '../../home/domain/model/country_summary.dart';
import '../../helper/route_helper.dart';
import '../../home/domain/repository/home_repo.dart';
import '../../utils/color_resources.dart';
import '../controller/favorite_controller.dart';
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

class FavoriteCountryItem extends StatelessWidget {
  final CountrySummary country;

  const FavoriteCountryItem({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
          tag: 'fav-country-flag-${country.cca2}',
          child: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
          
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: country.flag,
                fit: BoxFit.cover,
              ),
            ),
          )),
      title: Text(
        country.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Capital: ${country.capital}'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite_border, color: ColorResources.blackColor),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Remove from Favorites?'),
              content: Text('Remove ${country.name} from your favorites?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<FavoritesController>().removeFavorite(country);
                    Get.back();
                  },
                  child:
                      const Text('Remove', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
      onTap: () {
        Get.toNamed(
          RouteHelper.getDetailsRoute(country.cca2),
          arguments: country,
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
