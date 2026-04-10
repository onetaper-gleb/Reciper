import 'dart:io';

import 'package:dio/dio.dart';
import 'package:client/core/utils/app_logger.dart';

import '../dto/meal_plan/generate_meal_plan_request_dto.dart';
import '../dto/meal_plan/generate_meal_plan_response_dto.dart';
import 'api_endpoints.dart';

class ReciperApi {
  ReciperApi(this._dio);

  final Dio _dio;

  Future<GenerateMealPlanResponseDto> generateMealPlan(
    GenerateMealPlanRequestDto request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.generateMealPlan,
      data: request.toJson(),
    );
    return GenerateMealPlanResponseDto.fromJson(response.data!);
  }

  Future<Map<String, dynamic>> replaceMeal(Map<String, dynamic> requestJson) async {
    AppLogger.info('ReciperApi.replaceMeal request=$requestJson');
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.replaceMeal,
      data: requestJson,
    );
    AppLogger.info('ReciperApi.replaceMeal response=${response.data}');
    return response.data!;
  }

  // Stubs for later tasks (recipes / fridge scan). Kept to match planned API surface.
  Future<Map<String, dynamic>> suggestRecipes(Map<String, dynamic> requestJson) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.suggestRecipes,
      data: requestJson,
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> generateRecipe(Map<String, dynamic> requestJson) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.generateRecipe,
      data: requestJson,
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> scanFridge(
    File image, {
    String? existingProductsJson,
    String scanMode = 'replace',
    String? clientLocalDatetime,
  }) async {
    final fields = <String, dynamic>{
      'image': await MultipartFile.fromFile(image.path),
      'existing_products_json': existingProductsJson,
      'scan_mode': scanMode,
    };
    if (clientLocalDatetime != null) {
      fields['client_local_datetime'] = clientLocalDatetime;
    }
    final form = FormData.fromMap(fields);
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.scanFridge,
      data: form,
    );
    return response.data!;
  }
}

