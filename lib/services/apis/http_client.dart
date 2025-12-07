// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';

// class HttpClientService {
//   static HttpClientService? _instance;
//   late final Dio dio;
//   late final CookieJar cookieJar;

//   HttpClientService._() {
//     dio = Dio();
//     cookieJar = CookieJar(); // in-memory cookie storage
//     dio.interceptors.add(CookieManager(cookieJar));

//     // Optional: set default options
//     dio.options = BaseOptions(
//       connectTimeout: Duration(seconds: 10000),
//       receiveTimeout: Duration(seconds: 10000),
//       headers: {'Content-Type': 'application/json'},
//     );
//   }

//   static HttpClientService get instance {
//     _instance ??= HttpClientService._();
//     return _instance!;
//   }

//   // GET request
//   Future<Response> get(
//     String url, {
//     Map<String, dynamic>? queryParameters,
//     Map<String, dynamic>? headers,
//   }) {
//     return dio.get(
//       url,
//       queryParameters: queryParameters,
//       options: Options(headers: headers),
//     );
//   }

//   // POST request
//   Future<Response> post(
//     String url, {
//     dynamic data,
//     Map<String, dynamic>? headers,
//     bool sendAsJson = false, // optional flag
//   }) {
//     return dio.post(
//       url,
//       data: sendAsJson ? data : FormData.fromMap(data),
//       options: Options(
//         headers: headers,
//         contentType: sendAsJson
//             ? Headers.jsonContentType
//             : Headers.formUrlEncodedContentType,
//       ),
//     );
//   }

//   // PUT request
//   Future<Response> put(
//     String url, {
//     dynamic data,
//     Map<String, dynamic>? headers,
//   }) {
//     return dio.put(
//       url,
//       data: data,
//       options: Options(headers: headers),
//     );
//   }

//   // DELETE request
//   Future<Response> delete(
//     String url, {
//     dynamic data,
//     Map<String, dynamic>? headers,
//   }) {
//     return dio.delete(
//       url,
//       data: data,
//       options: Options(headers: headers),
//     );
//   }

//   // PATCH request
//   Future<Response> patch(
//     String url, {
//     dynamic data,
//     Map<String, dynamic>? headers,
//   }) {
//     return dio.patch(
//       url,
//       data: data,
//       options: Options(headers: headers),
//     );
//   }

//   void dispose() {
//     dio.close();
//     _instance = null;
//   }
// }
