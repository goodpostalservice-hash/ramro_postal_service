class HttpConfig {
  static String apiKey = '';
  static String webUrl = 'https://speedzcode.org';
  static String baseUrl = 'https://ramropostalservice.com';

  static String stgBaseUrl = 'https://ramropostalservice.com';
  static String prodBaseUrl = 'https://ramropostalservice.com';
  static String devBaseUrl = 'https://ramropostalservice.com';

  static const refreshToken = "/v1/auth/refresh";

  static const String login = '/v1/auth/login';

  static const String wallet = '/api/wallet';
  static const String todayEarning = '/api/driver/today-earnings';
  static const String earning = '/api/driver/earnings';

  static const String orderEstimate = '/api/order-estimate';

  static String orderDetail(int id) => '/api/driver/order-details/$id';

  static const String subscription = '/api/my-subscription';

  static const String placeOrder = '/api/place-order';
}
