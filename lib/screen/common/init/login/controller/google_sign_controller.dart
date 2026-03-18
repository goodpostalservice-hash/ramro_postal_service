import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ramro_postal_service/core/constants/app_constant.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import 'package:ramro_postal_service/core/network/network_dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:ramro_postal_service/screen/home_map/home_map_screen/presentation/driver_home_map_screen.dart';
import 'package:ramro_postal_service/screen/common/init/login/presentation/widget/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../base/base_controller.dart';
import '../../../../../core/constants/api_constant.dart';
import '../../password/screen/model/login_response_model.dart';

class GoogleSignInController extends BaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> signInWithGoogle(context) async {
  //   try {
  //     final GoogleSignIn signIn = GoogleSignIn.instance;
  //     unawaited(
  //       signIn.initialize(clientId: clientId, serverClientId: serverClientId).then((
  //         _,
  //       ) {
  //         signIn.authenticationEvents
  //             .listen(_handleAuthenticationEvent)
  //             .onError(_handleAuthenticationError);

  //         /// This example always uses the stream-based approach to determining
  //         /// which UI state to show, rather than using the future returned here,
  //         /// if any, to conditionally skip directly to the signed-in state.
  //         signIn.attemptLightweightAuthentication();
  //       }),
  //     );
  //     // 1. Ask user to choose a Google account

  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  //     // User closed the picker / cancelled
  //     if (googleUser == null) {
  //       showErrorMessage('Sign in cancelled');
  //       return;
  //     }

  //     // 2. Get Google tokens
  //     final GoogleSignInAuthentication googleAuth = googleUser.authentication;

  //     // 3. Build Firebase credential
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     // 4. Sign in to Firebase
  //     final UserCredential userCredential = await _auth.signInWithCredential(
  //       credential,
  //     );

  //     final User? user = userCredential.user;
  //     if (user == null || user.email == null) {
  //       showErrorMessage("Couldn't retrieve account info");
  //       return;
  //     }

  //     // 5. Show loading before hitting your backend
  //     DialogLoadingHelper.showLoading();

  //     final payload = {
  //       'email': user.email, // backend expects email to auth/register
  //     };

  //     final authResult = await restClient.request(
  //       ApiConstant.loginWithGoogle,
  //       Method.POST,
  //       payload,
  //     );

  //     // 6. Handle backend response
  //     if (authResult is dio.Response) {
  //       final responseData = LoginResponseModel.fromJson(authResult.data);

  //       if (responseData.success == true) {
  //         // store bearer token
  //         AppConstant.bearerToken = responseData.token.toString();

  //         // wipe and persist user session
  //         AppConstant.logInfo = [];

  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.clear();
  //         await prefs.setString('key', json.encode(authResult.data));
  //         AppConstant.logInfo.add(authResult.data);

  //         // capture location so map screens can start from last known pos
  //         final Position position = await Geolocator.getCurrentPosition();
  //         final LatLng currentLatLng = LatLng(
  //           position.latitude,
  //           position.longitude,
  //         );

  //         DriverHomeMapScreen.currentLocationAtStart = currentLatLng;
  //         HomeMapScreen.currentLocationAtStart = currentLatLng;

  //         DialogLoadingHelper.hideLoading();
  //         showSuccessMessage('Logged in');

  //         // Go to dashboard
  //         Get.offNamed('/dashboard');
  //       } else {
  //         DialogLoadingHelper.hideLoading();
  //         showErrorMessage('Failed to log in');
  //       }
  //     } else {
  //       DialogLoadingHelper.hideLoading();
  //       showErrorMessage('Unexpected server response');
  //     }
  //   } catch (e) {
  //     // always hide loader on exception
  //     DialogLoadingHelper.hideLoading();
  //     showErrorMessage(e.toString());
  //   }
  // }

  signInWithApple(context, String email) async {
    try {
      DialogLoadingHelper.showLoading();
      final map = {'email': email};

      final authResult = await restClient.request(
        ApiConstant.loginWithGoogle,
        Method.POST,
        map,
      );

      print(authResult);
      if (authResult != null) {
        if (authResult is dio.Response) {
          var responseData = LoginResponseModel.fromJson(authResult.data);
          if (responseData.success == true) {
            DialogLoadingHelper.hideLoading();
            AppConstant.bearerToken = responseData.token.toString();

            // after login clear the temp list and store new value
            AppConstant.logInfo = [];

            final userData = authResult.data;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            // clear all the values for sharedpreferences
            prefs.clear();

            // store new logged in data
            Map<String, dynamic> map = userData;
            prefs.setString('key', json.encode(map));

            // save in list
            AppConstant.logInfo.add(authResult.data);
            Position position = await Geolocator.getCurrentPosition();
            DriverHomeMapScreen.currentLocationAtStart = LatLng(
              position.latitude,
              position.longitude,
            );
            showSuccessMessage('logged in');

            Get.offNamed('/dashboard');
          } else {
            showErrorMessage("failed to log in");
          }
        }
      }
    } catch (e) {
      print(e.toString());
      showErrorMessage(e.toString());
    }
  }
}
