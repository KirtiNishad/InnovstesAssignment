part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherSuccess extends WeatherState {
  final WeatherDataModel weatherData;

  WeatherSuccess(this.weatherData);
}

final class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}