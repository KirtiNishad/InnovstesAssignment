import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:innovate_assignment/core/constant/endpoints.dart';
import 'package:innovate_assignment/core/helper/location_service.dart';
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
        final locationName = await LocationService.getLocationName(event.latitude, event.longitude);

        emit(WeatherSuccess(weatherData!, locationName));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
  }
}
