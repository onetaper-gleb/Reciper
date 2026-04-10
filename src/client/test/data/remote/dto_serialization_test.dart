import 'package:flutter_test/flutter_test.dart';

import 'package:client/data/remote/dto/meal_plan/generate_meal_plan_response_dto.dart';

void main() {
  test('GenerateMealPlanResponseDto fromJson/toJson roundtrip', () {
    const json = {
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
    };

    final dto = GenerateMealPlanResponseDto.fromJson(json);
    final encoded = dto.toJson();

    expect(encoded['plan'], isNotNull);
    expect((encoded['plan'] as Map)['days'], isNotEmpty);
    expect(
      (((encoded['plan'] as Map)['days'] as List).first as Map)['meals'],
      isNotEmpty,
    );
  });
}

