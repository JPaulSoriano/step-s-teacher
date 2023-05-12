// Create assessment
import 'dart:convert';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/assessment_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> createAssessment(
  String roomKey,
  String? title,
  String? description,
  String? start_date,
  String? end_date,
  String? grading,
  String? exam_type,
  String? flow,
  String? duration,
  String? items,
  String? passing_score,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse('$createAssessmentURL/$roomKey/createassessment'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'title': title,
          'description': description,
          'start_date': start_date,
          'end_date': end_date,
          'grading': grading,
          'exam_type': exam_type,
          'flow': flow,
          'duration': duration,
          'items': items,
          'passing_score': passing_score,
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Get room assessments

Future<ApiResponse> getAssessments(int roomId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$roomsURL/$roomId/assessments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['assessments']
            .map((p) => Assessment.fromJson(p))
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
