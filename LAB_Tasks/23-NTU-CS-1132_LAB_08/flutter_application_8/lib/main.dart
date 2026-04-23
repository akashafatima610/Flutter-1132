// main,dart
import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Controllers for latitude and longitude input fields
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lonController = TextEditingController();

  // Controller for city input field
  final TextEditingController _cityController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    // Trigger the API call when the screen loads
    _weatherFuture = _weatherService.fetchWeather(51.5074, -0.1278);
  }

  // Function to manually refresh data
  void _refreshWeather() {
    final lat = double.tryParse(_latController.text);
    final lon = double.tryParse(_lonController.text);

    if (lat != null && lon != null) {
      setState(() {
        _weatherFuture = _weatherService.fetchWeather(lat, lon);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Flutter LAB - 08 - Weather App")),
        backgroundColor: Colors.green,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshWeather,
          ),
        ],
      ),

      body: Center(
        child: FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            // State 1: Still loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // State 2: Error occurred
            else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            // State 3: Data successfully fetched
            else if (snapshot.hasData) {
              final weather = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'Enter City Name',
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            final city = _cityController.text.trim();

                            if (city.isNotEmpty) {
                              setState(() {
                                _weatherFuture = _weatherService
                                    .fetchWeatherByCity(city);
                              });
                            }
                          },
                          child: const Text('Search by City'),
                        ),
                        TextField(
                          controller: _latController,
                          decoration: const InputDecoration(
                            labelText: 'Latitude',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: _lonController,
                          decoration: const InputDecoration(
                            labelText: 'Longitude',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _refreshWeather,
                          child: const Text('Get Weather'),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Image.network(
                    'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  ),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather.description.toUpperCase(),
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              );
            }
            // Fallback state
            return const Text('No data available');
          },
        ),
      ),
    );
  }
}