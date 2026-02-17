import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovate_assignment/core/helper/location_service.dart';
import 'package:innovate_assignment/feature/thought/bloc/thought_bloc.dart';
import 'package:innovate_assignment/feature/thought/model/thought_data_repo.dart';
import 'package:innovate_assignment/feature/thought/thought_screen.dart';
import 'package:intl/intl.dart';
import '../bloc/weather_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List<String>? thought;
  @override
  void initState() {
    super.initState();
    _loadWeather();
    // context.read<ThoughtBloc>().add(ThoughtFetchEvent());
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
            final hourlyWeather = state.weatherData.hourly;
            final hourlyUnit = state.weatherData.hourlyUnits;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourlyWeather?.time?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                formatHourlyDate(
                                  hourlyWeather!.time?[index],
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(formatHourlyTime(hourlyWeather!.time?[index],)),
                              Text(
                                "${hourlyWeather.temperature2M?[index] ?? "--"} ${hourlyUnit?.temperature2M}",
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // BlocBuilder<ThoughtBloc, ThoughtState>(
                //   builder: (context, state) {
                //     if (state is ThoughtSuccess) {
                //       return Text("${state.data.a}");
                //     }else{
                //       return SizedBox();
                //     }
                //   },
                // ),

              ],
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

  String formatHourlyDate(String? time) {
    if (time == null) return "--";

    final dateTime = DateTime.parse(time);

    return DateFormat("dd MMM").format(dateTime);
  }

  String formatHourlyTime(String? time) {
    if (time == null) return "--";

    final dateTime = DateTime.parse(time);

    return DateFormat("hh:mm").format(dateTime);
  }
}
