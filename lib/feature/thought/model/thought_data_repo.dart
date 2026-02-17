import 'package:dio/dio.dart';
import 'package:innovate_assignment/feature/thought/model/thought_model.dart';

class ThoughtDataRepo{
  final Dio _dio = Dio();

  Future getThoughtOfDay() async {
    try {
      final response = await _dio.get("https://zenquotes.io/api/today");
      print("Response ========> ${response.data}");

      /*if(response.statusCode == 200){
        final data = response.data;
        return ThoughtModel.fromJson(data);
      }*/

      return response.data;
    } catch (e) {
      return e;
    }
  }
}