import 'dart:convert';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/question_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getQuestions(int topicId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$topicsURL/$topicId/questions'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['questions']
            .map((p) => Question.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }
  return apiResponse;
}
