import 'package:dio/dio.dart';

class ApiBaseClient {
  late final Dio dio;

  static final ApiBaseClient _instance = ApiBaseClient._internal();
  factory ApiBaseClient() => _instance;

  ApiBaseClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://api.open-meteo.com",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
        },
        responseType: ResponseType.json
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {

          print(
              "REQUEST => ${options.method} ${options.baseUrl}${options.path}");
          handler.next(options);
        },
        onResponse: (response, handler) {
          print("RESPONSE => ${response.statusCode}");
          handler.next(response);
        },
        onError: (DioException error, handler) {
          print("ERROR => ${error.message}");
          handler.next(error);
        },
      ),
    );
  }
}
