import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:project_kotrip/pages/plan/model/plan_model.dart';
import 'package:project_kotrip/pages/plan/view_model/plan_view_model.dart';

class GeminiRepository {
  final dio = Dio();
  final key = Uri.decodeFull(dotenv.env['GEMINI_API_KEY'] ?? '');
  final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<PlanState> geminiCreatePlan(
    String area,
    String date,
    String style, // 여행 스타일
    Set<String> themes, // 여행 테마
  ) async {
    final prompt =
        """
너는 대한민국 국내 여행 계획 전문가야. 아래 조건에 맞는 여행 계획을 만들어줘. 이동시간도 반드시 고려해야해. 각 식사 시간에는 최소 1개 이상의 실제 식당명을 추천해줘. 식당명은 실제 존재하는 장소인지 확인해줘.

조건:
- 여행지: $area
- 여행 기간: $date
- 여행 스타일: $style
- 여행 테마: ${themes.join(", ")}

결과는 반드시 아래 JSON 형식으로만 응답해:
{
  "days": [
    {
      "date": "2025-09-23",
      "plans": [
        {"time": "11:00-12:00", "place": "인사동", "todo": "전통 공예품 구경 및 차 마시기"},
        {"time": "10:00-12:00", "place": "인사동", "todo": "점심 식사(한정식) - [추천] 용수사 비원"}
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
      final cleanJson = resultTxt.replaceAll(RegExp(r'```json|```'), '').trim();
      final decodedTxt = jsonDecode(cleanJson);
      final daysList = decodedTxt['days'] as List;

      final planList = daysList.map((day) {
        final rawData = day['plans'] as List? ?? [];
        final plans = rawData.map((p) {
          return PlanModel(
            time: p['time'] ?? '',
            place: p['place'] ?? '',
            todo: p['todo'] ?? '',
          );
        }).toList();
        return plans;
      }).toList();

      final startDate = DateTime.tryParse(daysList.first['date'] ?? '') ?? DateTime.now();
      final endDate = DateTime.tryParse(daysList.last['date'] ?? '') ?? startDate;
      final startFormat = DateFormat('yy.MM.dd').format(startDate);
      final endFormat = DateFormat('yy.MM.dd').format(endDate);

      print('AI 계획 변환 결과: $planList');

      return PlanState(
        area: area,
        startDate: startDate,
        endDate: endDate,
        planList: planList,
        startFormat: startFormat,
        endFormat: endFormat,
      );
    } catch (e) {
      print('AI 계획 생성 에러: $e');
      return PlanState(
        area: area,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        planList: [],
        startFormat: '',
        endFormat: ''
      );
    }
  }
}
