// Get room materials
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/people_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/services/user_service.dart';

Future<ApiResponse> getPeople(int roomId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$roomsURL/$roomId/people'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['people']
            .map((p) => People.fromJson(p))
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
