import 'dart:io';

import 'package:dio/dio.dart';

import '../dto/meal_plan/generate_meal_plan_request_dto.dart';
import '../dto/meal_plan/generate_meal_plan_response_dto.dart';
import '../dto/meal_plan/replace_meal_request_dto.dart';
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

  Future<Map<String, dynamic>> replaceMeal(ReplaceMealRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.replaceMeal,
      data: request.toJson(),
    );
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

  Future<Map<String, dynamic>> scanFridge(
    File image, {
    String? existingProductsJson,
  }) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(image.path),
      if (existingProductsJson != null) 'existing_products_json': existingProductsJson,
    });
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.scanFridge,
      data: form,
    );
    return response.data!;
  }
}

