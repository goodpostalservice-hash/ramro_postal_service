class AppEntity<T> {
  final String? message;
  final bool? success;
  final T? data;

  AppEntity({this.message, this.success, this.data});
}
