import 'package:dio/dio.dart';
import 'package:healing/core/network/token_storage.dart';


class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra["retried"] != true) {

      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken == null) {
        return handler.next(err);
      }

      try {
        final response = await dio.post(
          "/api/auth/refresh",
          data: {"refreshToken": refreshToken},
          options: Options(extra: {"skipAuth": true}),
        );

        final newAccessToken = response.data["accessToken"];

        await TokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: refreshToken,
        );

        final requestOptions = err.requestOptions;

        requestOptions.headers["Authorization"] =
        "Bearer $newAccessToken";

        requestOptions.extra["retried"] = true;

        final clonedResponse = await dio.fetch(requestOptions);

        return handler.resolve(clonedResponse);
      } catch (_) {
        await TokenStorage.clearTokens();
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}