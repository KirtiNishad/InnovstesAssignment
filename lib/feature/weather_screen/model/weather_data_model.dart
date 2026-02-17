// To parse this JSON data, do
//
//     final weatherDataModel = weatherDataModelFromJson(jsonString);

import 'dart:convert';

WeatherDataModel weatherDataModelFromJson(String str) => WeatherDataModel.fromJson(json.decode(str));

String weatherDataModelToJson(WeatherDataModel data) => json.encode(data.toJson());

class WeatherDataModel {

  final num? latitude;
  final num? longitude;
  final num? generationtimeMs;
  final num? utcOffsetSeconds;
  final String? timezone;
  final String? timezoneAbbreviation;
  final num? elevation;
  final CurrentWeatherUnits? currentWeatherUnits;
  final CurrentWeather? currentWeather;
  final HourlyUnits? hourlyUnits;
  final Hourly? hourly;

  WeatherDataModel({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentWeatherUnits,
    this.currentWeather,
    this.hourlyUnits,
    this.hourly,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) => WeatherDataModel(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    generationtimeMs: json["generationtime_ms"]?.toDouble(),
    utcOffsetSeconds: json["utc_offset_seconds"],
    timezone: json["timezone"],
    timezoneAbbreviation: json["timezone_abbreviation"],
    elevation: json["elevation"],
    currentWeatherUnits: json["current_weather_units"] == null ? null : CurrentWeatherUnits.fromJson(json["current_weather_units"]),
    currentWeather: json["current_weather"] == null ? null : CurrentWeather.fromJson(json["current_weather"]),
    hourlyUnits: json["hourly_units"] == null ? null : HourlyUnits.fromJson(json["hourly_units"]),
    hourly: json["hourly"] == null ? null : Hourly.fromJson(json["hourly"]),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "generationtime_ms": generationtimeMs,
    "utc_offset_seconds": utcOffsetSeconds,
    "timezone": timezone,
    "timezone_abbreviation": timezoneAbbreviation,
    "elevation": elevation,
    "current_weather_units": currentWeatherUnits?.toJson(),
    "current_weather": currentWeather?.toJson(),
    "hourly_units": hourlyUnits?.toJson(),
    "hourly": hourly?.toJson(),
  };
}

class CurrentWeather {
  final String? time;
  final num? interval;
  final num? temperature;
  final num? windspeed;
  final num? winddirection;
  final num? isDay;
  final num? weathercode;

  CurrentWeather({
    this.time,
    this.interval,
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.isDay,
    this.weathercode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
    time: json["time"],
    interval: json["interval"],
    temperature: json["temperature"]?.toDouble(),
    windspeed: json["windspeed"]?.toDouble(),
    winddirection: json["winddirection"],
    isDay: json["is_day"],
    weathercode: json["weathercode"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "temperature": temperature,
    "windspeed": windspeed,
    "winddirection": winddirection,
    "is_day": isDay,
    "weathercode": weathercode,
  };
}

class CurrentWeatherUnits {
  final String? time;
  final String? interval;
  final String? temperature;
  final String? windspeed;
  final String? winddirection;
  final String? isDay;
  final String? weathercode;

  CurrentWeatherUnits({
    this.time,
    this.interval,
    this.temperature,
    this.windspeed,
    this.winddirection,
    this.isDay,
    this.weathercode,
  });

  factory CurrentWeatherUnits.fromJson(Map<String, dynamic> json) => CurrentWeatherUnits(
    time: json["time"],
    interval: json["interval"],
    temperature: json["temperature"],
    windspeed: json["windspeed"],
    winddirection: json["winddirection"],
    isDay: json["is_day"],
    weathercode: json["weathercode"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "interval": interval,
    "temperature": temperature,
    "windspeed": windspeed,
    "winddirection": winddirection,
    "is_day": isDay,
    "weathercode": weathercode,
  };
}

class Hourly {
  final List<String>? time;
  final List<num>? temperature2M;

  Hourly({
    this.time,
    this.temperature2M,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => Hourly(
    time: json["time"] == null ? [] : List<String>.from(json["time"]!.map((x) => x)),
    temperature2M: json["temperature_2m"] == null ? [] : List<num>.from(json["temperature_2m"]!.map((x) => x?.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "time": time == null ? [] : List<dynamic>.from(time!.map((x) => x)),
    "temperature_2m": temperature2M == null ? [] : List<dynamic>.from(temperature2M!.map((x) => x)),
  };
}

class HourlyUnits {
  final String? time;
  final String? temperature2M;

  HourlyUnits({
    this.time,
    this.temperature2M,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) => HourlyUnits(
    time: json["time"],
    temperature2M: json["temperature_2m"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "temperature_2m": temperature2M,
  };
}
