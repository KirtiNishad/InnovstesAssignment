import 'package:dio/dio.dart';
import 'package:innovate_assignment/feature/thought/model/thought_model.dart';

class ThoughtDataRepo{
  final Dio _dio = Dio(BaseOptions(responseType: ResponseType.json));

  Future getThoughtOfDay() async {
    try {
      final response = await _dio.get("https://zenquotes.io/api/today");

      if(response.statusCode == 200){
        final data = response.data;
        return data.map((e) => ThoughtModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error ==========> $e");
      return e;
    }
  }
}