import 'package:cached_network_image/cached_network_image.dart';
import 'package:countries/utils/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:countries/home/controller/home_controller.dart';
import 'package:countries/home/domain/model/country_summary.dart';
import 'package:countries/helper/route_helper.dart';

class CountryListItem extends StatelessWidget {
  final CountrySummary country;

  const CountryListItem({
    super.key, 
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
      // This ensures the widget rebuilds when favorites change
      buildWhen: (previous, current) {
        // Rebuild when we transition to HomeLoaded state
        // or when favorites change within HomeLoaded state
        if (previous is HomeLoaded && current is HomeLoaded) {
          final prevFavorite = previous.isFavorite(country.cca2);
          final currFavorite = current.isFavorite(country.cca2);
          return prevFavorite != currFavorite;
        }
        return current is HomeLoaded;
      },
      builder: (context, state) {
        final isFavorite = state is HomeLoaded 
            ? state.isFavorite(country.cca2)
            : false;
        
        return ListTile(
          leading: Hero(
  tag: 'country-flag-${country.cca2}',
  child: Container(
    width: 100,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: ColorResources.grey100Color,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: country.flag,
        fit: BoxFit.cover,
      ),
    ),
  ),
),
          title: SizedBox(
            width: 200,
            child: Text(
              country.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            'Population: ${country.formattedPopulation}',
            style: const TextStyle(fontSize: 14),
          ),
          trailing: FavoriteButton(
            country: country,
            isFavorite: isFavorite,
          ),
          onTap: () {
            Get.toNamed(RouteHelper.getDetailsRoute(country.cca2));
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        );
      },
    );
  }
}

// Separate widget for the favorite button to optimize rebuilds
class FavoriteButton extends StatelessWidget {
  final CountrySummary country;
  final bool isFavorite;

  const FavoriteButton({
    super.key,
    required this.country,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite), // Important for AnimatedSwitcher
          color: isFavorite ? ColorResources.redColor : ColorResources.blackColor,
          size: 30,
        ),
      ),
      onPressed: () async {
        final controller = context.read<HomeController>();
        await controller.toggleFavorite(country);
        
        // Optional: Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite 
                  ? 'Removed ${country.name} from favorites'
                  : 'Added ${country.name} to favorites',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}