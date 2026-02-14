import 'dart:convert';

import 'package:innovate_assignment/core/constant/endpoints.dart';
import 'package:innovate_assignment/core/services/api_base_client.dart';
import '../model/weather_data_model.dart';

class WeatherRepository {

  static Future<WeatherDataModel?> fetchWeatherData(double latitude, double longitude) async {

    try {
      final response = await ApiBaseClient().dio.get(
        Endpoints.forecast,
        queryParameters: {
          "latitude": latitude,
          "longitude": longitude,
          "current_weather": true,
        },
      );

      print("Response =========> ${response.data}");

      if(response.statusCode == 200){
        WeatherDataModel weatherData = WeatherDataModel.fromJson(response.data);

        print("Weather Data ========> ${weatherData.currentWeather?.temperature}");

        return weatherData;
      }
    } on Exception catch ( e) {
      print("Error ---> ${e}");
      rethrow;
    }
    return null;
  }
}
