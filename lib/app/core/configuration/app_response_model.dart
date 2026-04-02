import 'app_entity.dart';

class AppResponse<T> extends AppEntity<T> {
  factory AppResponse.fromJson(Map<String, dynamic> json) => AppResponse(
    success: json["success"] as bool? ?? false,
    message: json["message"] as String?,
    data: json as T?,
  );

  AppResponse({required bool super.success, super.message, super.data});

  AppResponse.withError({
    required String super.message,
    bool super.success = false,
    super.data,
  });

  bool get isSuccess => success ?? false;
}


