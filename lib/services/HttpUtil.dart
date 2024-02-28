import 'package:dio/dio.dart';

import '../constants/constants.dart';

class HttpUtil {
  Dio dio;
  HttpUtil._internal() : dio = Dio() {
    _initializeDio();
  }

  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() {
    return _instance;
  }

  void _initializeDio() {
    dio.options = BaseOptions(
      baseUrl: SERVER_API_URL,
      connectTimeout: const Duration(milliseconds: 6000),
      receiveTimeout: const Duration(milliseconds: 6000),
      followRedirects: true, // Enable following redirects
      maxRedirects: 5,
      headers: {
        //   // "Content-Type": "application/json",
        //   // 'Authorization': 'Bearer $token',
        'Accept': '*',
      },
      contentType: "application/json",
      // contentType: "application/json: charset=utf-8",
      // contentType: "*",
      // responseType: ResponseType.json,
      responseType: ResponseType.json,
    );

    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  void changeBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
  }

  Future post(String path,
      {dynamic data, dynamic queryParameters, Options? options}) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    // Map<String, dynamic>? authorization = getAuthorizationHeader();
    // if (authorization != null) {
    //   requestOptions.headers!.addAll(authorization);
    // }
   // print(path);
    // print(data);
   // print(queryParameters);
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
    );
    // var response =
    //     await dio.post(path, data: data, queryParameters: queryParameters);
   // print(data);
   // print(queryParameters);

   // print(requestOptions);
   // print(response.toString());
   // print("my response is ${response.toString()}");
  //  print("my status code is ${response.statusCode.toString()}");
   // print("data${data}");
    return response.data;
  }

  Future get(String path, {Options? options, dynamic queryParameters}) async {
    Options requestOptions = options ?? Options();
    //print(path);
    var response = await dio.get(path,
        options: requestOptions, queryParameters: queryParameters);
   // print("Request: ${dio.options.baseUrl}${path}");
   // print("Headers: ${dio.options.headers}");
   // print(requestOptions);
  //  print(response.toString());
  //  print("my response is ${response.data.toString()}");
  //  print("my status code is ${response.statusCode.toString()}");

    return response.data;
  }
}
