import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_kotrip/pages/plan/data/plan_model.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class GeminiRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['GEMINI_API_KEY'] ?? '');
  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<PlanState> geminiCreatePlan(
    String area,
    String date,
    Set<String> themes, // 여행 테마
  ) async {
    final prompt =
        """
너는 여행 계획 전문가야. 아래 조건에 맞는 여행 계획을 만들어줘.

조건:
- 여행지: $area
- 여행 기간: $date
- 여행 테마: ${themes.join(", ")}

결과는 반드시 아래 JSON 형식으로만 응답해:
{
  "days": [
    {
      "date": "2025-09-23",
      "plans": [
        {"time": "09:00-10:00", "place": "제주 동문시장", "todo": "향토 음식 구경 및 시식"},
        {"time": "10:00-12:00", "place": "제주 민속촌", "todo": "문화 체험"}
      ]
    }
  ]
}
설명, 여는 말, 닫는 말 없이 JSON 데이터만 응답해.
""";

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json', 'X-goog-api-key': key},
        ),
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        },
      );

      final resultTxt = response.data['candidates'][0]['content']['parts'][0]['text'];
      print('AI raw response: $resultTxt');

      final cleanJson = resultTxt.replaceAll(RegExp(r'```json|```'), '').trim();
      final decodedTxt = jsonDecode(cleanJson);
      final days = decodedTxt['days'] as List;

      final planList = days.map((day) {
        final rawPlans = day['plans'] as List? ?? [];
        final plans = rawPlans.map((p) {
          return PlanModel(
            time: p['time'] ?? '',
            place: p['place'] ?? '',
            todo: p['todo'] ?? '',
          );
        }).toList();
        return plans;
      }).toList();

      final startDate = DateTime.tryParse(days.first['date'] ?? '') ?? DateTime.now();
      final endDate = DateTime.tryParse(days.last['date'] ?? '') ?? startDate;

      print('AI 계획 변환 결과: $planList');

      return PlanState(
        area: area,
        startDate: startDate,
        endDate: endDate,
        planList: planList,
      );
    } catch (e) {
      print('AI 계획 생성 에러: $e');
      return PlanState(
        area: area,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        planList: [],
      );
    }
  }
}
