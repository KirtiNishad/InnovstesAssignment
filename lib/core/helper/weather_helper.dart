import 'package:flutter/material.dart';

class WeatherHelper {
  static IconData getWeatherIcon(int? code, int? isDay) {
    final bool day = isDay == 1;

    switch (code) {
      case 0:
        return day ? Icons.wb_sunny : Icons.nightlight_round;

      case 1:
      case 2:
        return Icons.cloud_queue;

      case 3:
        return Icons.cloud;

      case 45:
      case 48:
        return Icons.foggy;

      case 51:
      case 61:
      case 63:
      case 65:
        return Icons.grain;

      case 71:
      case 73:
      case 75:
        return Icons.ac_unit;

      case 95:
        return Icons.flash_on;

      default:
        return Icons.cloud;
    }
  }

  static String getWeatherText(int? code) {
    switch (code) {
      case 0:
        return "Clear Sky";
      case 1:
      case 2:
        return "Partly Cloudy";
      case 3:
        return "Cloudy";
      case 61:
      case 63:
      case 65:
        return "Rainy";
      case 71:
        return "Snow";
      case 95:
        return "Thunderstorm";
      default:
        return "Unknown";
    }
  }
}
