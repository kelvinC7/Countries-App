import 'package:equatable/equatable.dart';

class CountryDetails extends Equatable {
  final String name;
  final String flag;
  final int population;
  final String capital;
  final String region;
  final String subregion;
  final double area;
  final List<String> timezones;

  const CountryDetails({
    required this.name,
    required this.flag,
    required this.population,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.timezones,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) {

    
    try {
      // Safely parse name
      String countryName = 'Unknown';
      if (json['name'] != null) {
        if (json['name'] is Map) {
          countryName = json['name']['common']?.toString() ?? 
                       json['name']['official']?.toString() ?? 
                       'Unknown';
        } else if (json['name'] is String) {
          countryName = json['name'];
        }
      }
      
      // Safely parse flag
      String flagUrl = '';
      if (json['flags'] != null) {
        if (json['flags'] is Map) {
          flagUrl = json['flags']['png']?.toString() ?? 
                   json['flags']['svg']?.toString() ?? 
                   json['flags']?.toString() ?? 
                   '';
        } else if (json['flags'] is String) {
          flagUrl = json['flags'];
        }
      }
      
      // Safely parse capital
      String capitalCity = 'N/A';
      if (json['capital'] != null) {
        if (json['capital'] is List) {
          if (json['capital'].isNotEmpty) {
            capitalCity = json['capital'][0].toString();
          }
        } else if (json['capital'] is String) {
          capitalCity = json['capital'];
        }
      }
      
      // Safely parse population
      int populationValue = 0;
      if (json['population'] != null) {
        if (json['population'] is int) {
          populationValue = json['population'];
        } else if (json['population'] is num) {
          populationValue = (json['population'] as num).toInt();
        } else if (json['population'] is String) {
          populationValue = int.tryParse(json['population']) ?? 0;
        }
      }
      
      // Safely parse area
      double areaValue = 0.0;
      if (json['area'] != null) {
        if (json['area'] is double) {
          areaValue = json['area'];
        } else if (json['area'] is int) {
          areaValue = (json['area'] as int).toDouble();
        } else if (json['area'] is num) {
          areaValue = (json['area'] as num).toDouble();
        } else if (json['area'] is String) {
          areaValue = double.tryParse(json['area']) ?? 0.0;
        }
      }
      
      // Safely parse region and subregion
      String regionValue = json['region']?.toString() ?? 'Unknown';
      String subregionValue = json['subregion']?.toString() ?? 'Unknown';
      
      // Safely parse timezones
      List<String> timezonesList = [];
      if (json['timezones'] != null) {
        if (json['timezones'] is List) {
          timezonesList = List<String>.from(
            json['timezones'].map((tz) => tz.toString())
          );
        }
      }
    
      
      return CountryDetails(
        name: countryName,
        flag: flagUrl,
        population: populationValue,
        capital: capitalCity,
        region: regionValue,
        subregion: subregionValue,
        area: areaValue,
        timezones: timezonesList,
      );
    } catch (e) {
    
      rethrow;
    }
  }

  String get formattedArea {
    if (area >= 1000000) {
      return '${(area / 1000000).toStringAsFixed(1)}M km²';
    } else if (area >= 1000) {
      return '${(area / 1000).toStringAsFixed(1)}K km²';
    }
    return '${area.toStringAsFixed(0)} km²';
  }

  String get formattedPopulation {
    if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)}M';
    } else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    return population.toString();
  }

  @override
  List<Object> get props => [
    name, 
    flag, 
    population, 
    capital, 
    region, 
    subregion, 
    area, 
    timezones
  ];
}