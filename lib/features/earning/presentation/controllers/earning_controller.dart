import 'package:get/get.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/earning_response.dart';
import '../../data/models/today_earning_response.dart';
import '../../domain/usecases/get_today_earning_usecase.dart';
import '../../domain/usecases/get_earning_usecase.dart';

class EarningController extends GetxController {
  // USECASE_FIELDS_START

  final GetTodayEarningUseCase getTodayEarningUseCase;
  final GetEarningUseCase getEarningUseCase;
  // USECASE_FIELDS_END

  EarningController({
    // USECASE_CONSTRUCTOR_START
    required this.getTodayEarningUseCase,
    required this.getEarningUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  var todayEarningResult = TodayEarningResponse().obs;
  var totalEarningResult = EarningResponse().obs;

  @override
  void onReady() {
    super.onReady();
    getTodayEarning();
    getEarning();
  }

  // API_METHODS_START
  // API_METHODS_END
  Future<void> getTodayEarning() async {
    try {
      isLoading.value = true;

      final result = await getTodayEarningUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          todayEarningResult.value = response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getEarning() async {
    try {
      isLoading.value = true;

      final result = await getEarningUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          totalEarningResult.value = response;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
