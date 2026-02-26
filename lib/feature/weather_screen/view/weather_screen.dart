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
    context.read<ThoughtBloc>().add(ThoughtFetchEvent());
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),

        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {

            String location = "Fetching location...";

            if (state is WeatherSuccess) {
              location = state.locationName;

              print("Location Name ========> ${state.locationName}");
            }

            return AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: false,

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Weather Now",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh,
                      color: Colors.black87),
                  onPressed: () => _loadWeather(),
                ),
              ],
            );
          },
        ),
      ),

      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherSuccess) {
            final weather = state.weatherData.currentWeather;
            final units = state.weatherData.currentWeatherUnits;
            final hourlyWeather = state.weatherData.hourly;
            final hourlyUnit = state.weatherData.hourlyUnits;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ================= WEATHER HERO CARD =================
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black26,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "${weather?.temperature ?? "--"} ${units?.temperature ?? ""}",
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          formatDateTime(weather?.time),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoTile(
                              "Wind",
                              "${weather?.windspeed} ${units?.windspeed}",
                            ),
                            _infoTile(
                              "Direction",
                              "${weather?.winddirection}°",
                            ),
                            _infoTile(
                              "Status",
                              weather?.isDay == 1 ? "🌞 Day" : "🌙 Night",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  /// ================= HOURLY FORECAST =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Hourly Forecast",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: hourlyWeather?.time?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 90,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black12,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatHourlyTime(hourlyWeather!.time?[index]),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Icon(Icons.wb_sunny_outlined),
                              const SizedBox(height: 8),
                              Text(
                                "${hourlyWeather.temperature2M?[index] ?? "--"}°",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= DAILY THOUGHT =================
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocBuilder<ThoughtBloc, ThoughtState>(
                      builder: (context, state) {
                        if (state is ThoughtSuccess) {
                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "💬 Thought of the Day",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  state.data.first.q,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "— ${state.data.first.a}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            );

            /*Column(
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
                              Text(formatHourlyTime(hourlyWeather.time?[index],)),
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

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<ThoughtBloc, ThoughtState>(
                    builder: (context, state) {
                      if (state is ThoughtSuccess) {
                        print("thought ============> ${state.data}");
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: Text("${state.data.first.q}")),
                            Text("~ ${state.data.first.a}"),
                          ],
                        );
                      }else{
                        return SizedBox(
                          child: Text("Error"),
                        );
                      }
                    },
                  ),
                ),

              ],
            );*/
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

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
