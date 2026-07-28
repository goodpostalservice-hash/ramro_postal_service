import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/my_subscription_response.dart';
import '../../domain/usecases/get_my_subscription_usecase.dart';
import '../../domain/usecases/renew_subscription_usecase.dart';
import '../../data/models/subscribe_request.dart';
import '../../domain/usecases/subscribe_package_usecase.dart';

class SubscriptionController extends GetxController {
  // USECASE_FIELDS_START

  final GetMySubscriptionUseCase getMySubscriptionUseCase;

  final RenewSubscriptionUseCase renewSubscriptionUseCase;
  final SubscribePackageUseCase subscribePackageUseCase;
  // USECASE_FIELDS_END

  SubscriptionController({
    // USECASE_CONSTRUCTOR_START
    required this.getMySubscriptionUseCase,
    required this.renewSubscriptionUseCase,
    required this.subscribePackageUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isGettingMySubscription = false.obs;
  final isRenewingSubscription = false.obs;
  final isSubscribingPackage = false.obs;
  final mySubscription = Rxn<MySubscriptionResponse>();
  final errorMessage = RxnString();

  Future<void> getMySubscription() async {
    try {
      isGettingMySubscription.value = true;
      errorMessage.value = null;

      final result = await getMySubscriptionUseCase(const NoParams());

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar('Error', failure.message);
        },
        (response) {
          mySubscription.value = response;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isGettingMySubscription.value = false;
    }
  }

  Future<void> renewSubscription(SubscribeRequest request) async {
    try {
      isRenewingSubscription.value = true;

      final result = await renewSubscriptionUseCase(request);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          Get.snackbar('Success', 'Request completed successfully');
          getMySubscription();
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isRenewingSubscription.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getMySubscription();
  }

  Future<void> subscribePackage(SubscribeRequest request) async {
    try {
      isSubscribingPackage.value = true;

      final result = await subscribePackageUseCase(request);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          if (response.success == true) {
            getMySubscription();
            Get.snackbar('Success', response.message);
          } else {
            Get.snackbar('Error', response.message);
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSubscribingPackage.value = false;
    }
  }
}
