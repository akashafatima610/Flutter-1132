// weather_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  // Replace with your actual API key
  static const String apiKey = '849eb28ba5fa37db007b251642e6b137';
  // Using London's coordinates as default for the lab
  static const double lat = 51.5074;
  static const double lon = -0.1278;

  Future<Weather> fetchWeather(double lat, double lon) async {
    // We add &units=metric to get Celsius instead of Kelvin
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON data
      final jsonResponse = jsonDecode(response.body);
      return Weather.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, double>> getCoordinates(String city) async {
    final encodedCity = Uri.encodeComponent(city);

    final url = Uri.parse(
      'https://api.openweathermap.org/geo/1.0/direct?q=$encodedCity&limit=1&appid=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data != null && data.isNotEmpty) {
        return {
          'lat': (data[0]['lat'] as num).toDouble(),
          'lon': (data[0]['lon'] as num).toDouble(),
        };
      } else {
        throw Exception('City not found');
      }
    } else {
      throw Exception('Failed to get coordinates');
    }
  }

  Future<Weather> fetchWeatherByCity(String city) async {
    if (city.trim().isEmpty) {
      throw Exception('Please enter a city name');
    }

    final coords = await getCoordinates(city);
    return fetchWeather(coords['lat']!, coords['lon']!);
  }
}