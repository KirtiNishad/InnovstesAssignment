import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovate_assignment/feature/thought/bloc/thought_bloc.dart';

class ThoughtScreen extends StatefulWidget {
  const ThoughtScreen({super.key});

  @override
  State<ThoughtScreen> createState() => _ThoughtScreenState();
}

class _ThoughtScreenState extends State<ThoughtScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThoughtBloc, ThoughtState>(
        builder: (context, state) {
          if (state is ThoughtSuccess) {
            return Text("${state.data.a}");
          }else{
            return SizedBox();
          }
        },
      ),
    );
  }
}
