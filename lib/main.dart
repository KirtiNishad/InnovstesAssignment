import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovate_assignment/feature/thought/bloc/thought_bloc.dart';
import 'package:innovate_assignment/feature/thought/thought_screen.dart';
import 'package:innovate_assignment/feature/weather_screen/bloc/weather_bloc.dart';
import 'package:innovate_assignment/feature/weather_screen/view/weather_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WeatherBloc(),),
        BlocProvider(create: (context) => ThoughtBloc(),),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: WeatherScreen()
      ),
    );
  }
}