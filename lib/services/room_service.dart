import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/room_model.dart';
import 'package:stepteacher/services/user_service.dart';

Future<ApiResponse> getRooms() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(roomsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['rooms']
            .map((p) => Room.fromJson(p))
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
