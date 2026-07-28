import 'package:get/get.dart';
import '../../data/models/delete_qr_request.dart';
import '../../data/models/my_qr_response.dart';
import '../../domain/usecases/generateQR_usecase.dart';
import '../../data/models/generate_qr_request.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/getMyQR_usecase.dart';
import '../../domain/usecases/delete_qr_usecase.dart';

class QrController extends GetxController {
  // USECASE_FIELDS_START

  final GenerateqrUseCase generateqrUseCase;
  final GetmyqrUseCase getmyqrUseCase;
  final DeleteQrUseCase deleteQrUseCase;
  // USECASE_FIELDS_END

  QrController({
    // USECASE_CONSTRUCTOR_START
    required this.generateqrUseCase,
    required this.getmyqrUseCase,
    required this.deleteQrUseCase,
    // USECASE_CONSTRUCTOR_END
  });

  final isLoading = false.obs;
  final isDeleting = false.obs;
  RxBool isBottomPanelLoading = false.obs;
  RxList<MyQRResponse> qrList = <MyQRResponse>[].obs;

  MyQRResponse? get homeQr {
    for (final qr in qrList) {
      if (qr.label?.toLowerCase() == 'home') {
        return qr;
      }
    }
    return null;
  }

  // API_METHODS_START
  // API_METHODS_END

  @override
  void onInit() {
    super.onInit();
    getmyqr();
  }

  Future<void> generateqr(GenerateQrRequest request) async {
    try {
      isBottomPanelLoading.value = true;

      final result = await generateqrUseCase(request);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          getmyqr();
          Get.snackbar('Success', 'QR generated successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isBottomPanelLoading.value = false;
    }
  }

  Future<void> getmyqr() async {
    try {
      isLoading.value = true;

      final result = await getmyqrUseCase(const NoParams());

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          qrList.assignAll(response);
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteQr(DeleteQrRequest request) async {
    try {
      isDeleting.value = true;

      final result = await deleteQrUseCase(request);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.message);
        },
        (response) {
          qrList.removeWhere((item) => item.id == request.qrcode_id);
          Get.snackbar('Success', 'QR deleted successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isDeleting.value = false;
    }
  }
}
