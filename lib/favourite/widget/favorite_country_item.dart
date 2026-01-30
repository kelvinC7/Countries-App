import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../helper/route_helper.dart';
import '../../home/domain/model/country_summary.dart';
import '../../utils/color_resources.dart';
import '../../utils/dimentions.dart';
import '../controller/favorite_controller.dart';

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
        icon:
            const Icon(Icons.favorite, color: ColorResources.redColor, size: Dimentions.iconSizeDefault),
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