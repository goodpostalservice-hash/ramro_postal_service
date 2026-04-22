import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ramro_postal_service/core/error/toast.dart';
import '../../../../base/base_controller.dart';
import '../../../../core/constants/api_constant.dart';
import 'package:dio/dio.dart' as dio;

import '../../../../core/network/network_dio.dart';
import '../model/search_model_response.dart';

class SearchMapController extends BaseController {
  final RxList<SearchAddress> searchResultList = <SearchAddress>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> getSearchAddresses(String? data) async {
    try {
      final query = data?.trim() ?? '';

      if (query.isEmpty) {
        searchResultList.clear();
        return;
      }

      isLoading.value = true;

      final map = {"query": query};

      final result = await restClient.request(
        ApiConstant.searchResult,
        Method.GET,
        map,
      );

      if (result != null && result is dio.Response) {
        final responseData = result.data;

        debugPrint("SEARCH RESPONSE TYPE: ${responseData.runtimeType}");
        debugPrint("SEARCH RESPONSE DATA: $responseData");

        if (responseData is Map<String, dynamic>) {
          final response = SearchModel.fromJson(responseData);
          searchResultList.assignAll(response.data);
        } else {
          searchResultList.clear();
          showErrorMessage('Unexpected response format');
        }
      } else {
        searchResultList.clear();
        showErrorMessage('No response from server');
      }
    } catch (e, s) {
      debugPrint("SEARCH ERROR: $e");
      debugPrint("$s");
      searchResultList.clear();
      showErrorMessage('Something went wrong. Please try again later.');
    } finally {
      isLoading.value = false;
    }
  }

  void clearResults() {
    searchResultList.clear();
  }
}
