import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/remote/dto/meal_plan/generate_meal_plan_response_dto.dart';
import 'package:client/data/remote/mappers/meal_plan_mapper.dart';

void main() {
  test('MealPlanMapper maps response DTO to generated graph', () {
    final dto = GenerateMealPlanResponseDto.fromJson(const {
      'plan': {
        'start_date': '2026-04-06',
        'end_date': '2026-04-12',
        'days': [
          {
            'date': '2026-04-06',
            'meals': [
              {
                'meal_type': 'breakfast',
                'recipe': {
                  'name': 'Omelette',
                  'cooking_time_min': 10,
                  'nutrition': {
                    'calories': 400,
                    'protein_g': 20,
                    'fat_g': 20,
                    'carbs_g': 30,
                  },
                  'ingredients': [
                    {'name': 'Eggs', 'amount': 2, 'unit': 'pcs'}
                  ],
                  'steps': [
                    {'order': 1, 'description': 'Cook eggs'}
                  ],
                }
              }
            ]
          }
        ]
      },
      'weekly_summary': {
        'avg_calories': 400,
        'avg_protein_g': 20,
        'avg_fat_g': 20,
        'avg_carbs_g': 30,
      }
    });

    final graph = MealPlanMapper.toGeneratedGraph(dto);

    expect(graph.days, hasLength(1));
    expect(graph.days.first.meals, hasLength(1));
    expect(graph.days.first.meals.first.recipe.title, 'Omelette');
  });
}

