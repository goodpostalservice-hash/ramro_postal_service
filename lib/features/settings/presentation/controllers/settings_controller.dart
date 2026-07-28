import 'package:get/get.dart';
import 'package:ramro_postal_service/features/settings/data/models/terms_data.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/privacy_data.dart';
import '../../domain/usecases/get_terms_and_conditions_usecase.dart';
import '../../domain/usecases/get_privacy_policy_usecase.dart';

class SettingsController extends GetxController {
  // USECASE_FIELDS_START

  final GetTermsAndConditionsUseCase getTermsAndConditionsUseCase;
  final GetPrivacyPolicyUseCase getPrivacyPolicyUseCase;
  // USECASE_FIELDS_END

  SettingsController({
    // USECASE_CONSTRUCTOR_START
    required this.getTermsAndConditionsUseCase,
    required this.getPrivacyPolicyUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isGettingTermsAndConditions = false.obs;
  final isGettingPrivacyPolicy = false.obs;
  final termsAndConditionsData = Rxn<TermsData>();
  final privacyPolicyData = Rxn<PrivacyData>();

  // API_METHODS_START
  // API_METHODS_END

  @override
  onInit() {
    super.onInit();
    getTermsAndConditions();
    getPrivacyPolicy();
  }

  Future<void> getTermsAndConditions() async {
    try {
      isGettingTermsAndConditions.value = true;
      termsAndConditionsData.value = null;

      final result = await getTermsAndConditionsUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          termsAndConditionsData.value = response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isGettingTermsAndConditions.value = false;
    }
  }

  Future<void> getPrivacyPolicy() async {
    try {
      isGettingPrivacyPolicy.value = true;
      privacyPolicyData.value = null;

      final result = await getPrivacyPolicyUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          privacyPolicyData.value = response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isGettingPrivacyPolicy.value = false;
    }
  }
}
