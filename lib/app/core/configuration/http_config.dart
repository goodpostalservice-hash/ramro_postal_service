class HttpConfig {
  static String apiKey = '';
  static String webUrl = 'https://speedzcode.org';
  static String baseUrl = 'https://lms-api.staging.oneaccord.cc/api';

  static String stgBaseUrl = 'https://lms-api.staging.oneaccord.cc/api';
  static String prodBaseUrl = 'https://lms-api.oneaccord.cc/api';
  static String devBaseUrl = 'https://lms-api.staging.oneaccord.cc/api';

  static const refreshToken = "/v1/auth/refresh";

  static const String login = '/v1/auth/login';

  static const String dashboard = '/v1/dashboard';

  static const String forgotPassword = '/v1/auth/forgot-password';

  static const String logout = '/v1/auth/logout';

  static const String signup = '/v1/auth/signup';

  static const String onboarding = '/v2/onboarding';

  static const String userProfile = '/v1/users/profile';

  static const String searchUsers = '/v2/users/search';

  static String otherUserProfile(String id) => '/v1/users/$id/profile';

  static const String verifyResetCode = '/v1/auth/verify-reset-code';

  static const String resetPassword = '/v1/auth/reset-password';

  static const String sendVerificationCode = '/v1/auth/send-verification-code';

  static const String verifyCode = '/v1/auth/verify-code';

  static const String friends = '/v2/friends';

  static const String requestCount = '/v2/friends/requests/count';
  static const String friendRequest = '/v2/friends/requests';

  static const String sendRequest = '/v2/friends/requests';

  static String acceptRequest(String profileId) =>
      '/v2/friends/users/$profileId/accept';

  static String declineRequest(String profileId) =>
      '/v2/friends/users/$profileId/decline';

  static String cancelRequest(String profileId) =>
      '/v2/friends/users/$profileId/cancel';

  static String unfriend(String profileId) =>
      '/v2/friends/users/$profileId/unfriend';

  static const String publicLessonIntro = '/v2/public/lessons/onboarding/intro';

  static const String publicLessonQuestion =
      '/v2/public/lessons/onboarding/questions';

  static const String publicLessonVerifyAnswer =
      '/v2/public/lessons/onboarding/verify-answer';
}
