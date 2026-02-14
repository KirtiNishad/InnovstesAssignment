import 'package:bloc/bloc.dart';
import 'package:innovate_assignment/core/constant/endpoints.dart';
import 'package:innovate_assignment/core/services/api_base_client.dart';
import 'package:innovate_assignment/feature/weather_screen/model/weather_data_model.dart';
import 'package:innovate_assignment/feature/weather_screen/model/weather_repository.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeatherEvent>((event, emit) async {
      print("FetchWeatherEvent");
      try {
        emit(WeatherLoading());

        WeatherDataModel? weatherData = await WeatherRepository.fetchWeatherData(event.latitude, event.longitude);

        print("Weather Data =============> ${weatherData?.currentWeather?.temperature}");
        emit(WeatherSuccess(weatherData!));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
  }
}
