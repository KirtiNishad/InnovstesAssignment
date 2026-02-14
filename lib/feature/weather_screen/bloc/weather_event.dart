part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  FetchWeatherEvent({
    required this.latitude,
    required this.longitude,
  });
}

/// 🔹 Refresh weather
class RefreshWeatherEvent extends WeatherEvent {
  final String city;

  RefreshWeatherEvent({required this.city});
}