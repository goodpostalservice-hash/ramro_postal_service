import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/profile_response.dart';
import '../../domain/usecases/getProfile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../data/models/update_profile_request.dart';

class ProfileController extends GetxController {
  // USECASE_FIELDS_START

  final GetprofileUseCase getprofileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  // USECASE_FIELDS_END

  ProfileController({
    // USECASE_CONSTRUCTOR_START
    required this.getprofileUseCase,
    required this.updateProfileUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  Rx<ProfileResponse> resultList = ProfileResponse().obs;
  final RxBool notifEnabled = false.obs;
  final RxBool locationEnabled = true.obs;
  final isButtonVisible = true.obs;

  final isUpdateLoading = false.obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();

  // API_METHODS_START
  // API_METHODS_END

  @override
  onInit() {
    super.onInit();
    getprofile();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dobController.dispose();
    genderController.dispose();
    super.onClose();
  }

  Future<void> getprofile() async {
    try {
      isLoading.value = true;

      final result = await getprofileUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          resultList.value = response;
          firstNameController.text = resultList.subject.value!.firstName
              .toString();
          lastNameController.text = resultList.subject.value!.lastName
              .toString();
          emailController.text = resultList.subject.value!.email.toString();
          phoneController.text = resultList.subject.value!.phone.toString();
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(UpdateProfileRequest request) async {
    try {
      isUpdateLoading.value = true;

      final result = await updateProfileUseCase(request);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          getprofile();
          Get.snackbar('Success', 'Request completed successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUpdateLoading.value = false;
    }
  }

  void handleClick() {
    if (isButtonVisible.value == true) {
      isButtonVisible.value = false;
    } else {
      isButtonVisible.value = true;
    }
  }
}
