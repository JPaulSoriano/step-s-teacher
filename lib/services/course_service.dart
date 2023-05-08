import 'dart:convert';

import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/courses_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getCourses() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(coursesURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['courses']
            .map((p) => Course.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
