import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovate_assignment/core/helper/location_service.dart';
import 'package:intl/intl.dart';
import '../bloc/weather_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {

      final position = await LocationService.getCurrentLocation();

      context.read<WeatherBloc>().add(
        FetchWeatherEvent(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

    } catch (e) {
      debugPrint("Location Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: const Text("Current Weather"), centerTitle: true),

      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherSuccess) {
            final weather = state.weatherData.currentWeather;
            final units = state.weatherData.currentWeatherUnits;

            return Center(
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${weather?.temperature ?? "--"} ${units?.temperature ?? ""}",
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Time: ${formatDateTime(weather?.time)}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        "Wind Speed: ${weather?.windspeed} ${units?.windspeed}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      /// Wind Direction
                      Text(
                        "Wind Direction: ${weather?.winddirection}°",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weather?.isDay == 1 ? "Day 🌞" : "Night 🌙",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          } else if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      context.read<WeatherBloc>().add(
                        FetchWeatherEvent(
                          latitude: 28.6519,
                          longitude: 77.2315,
                        ),
                      );
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  String formatDateTime(String? time) {
    if (time == null) return "--";

    final dateTime = DateTime.parse(time);

    return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
  }
}
