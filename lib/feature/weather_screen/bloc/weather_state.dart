part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

/// Loading State (API call in progress)
final class WeatherLoading extends WeatherState {}

/// Success State (Data received)
final class WeatherSuccess extends WeatherState {
  final WeatherDataModel weatherData;

  WeatherSuccess(this.weatherData);
}

/// Error State (API failed)
final class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}