import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/attendance_model.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/services/user_service.dart';

Future<ApiResponse> getAttendances(int roomId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$roomsURL/$roomId/attendances'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['attendances']
            .map((p) => Attendance.fromJson(p))
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
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> createAttendance(
  String roomKey,
  String? grading,
  String? attendance_date,
  String? description,
  String? expiry_date,
  String? expiry_time,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse('$createAttendanceURL/$roomKey/createattendance'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'grading': grading,
          'attendance_date': attendance_date,
          'description': description,
          'expiry_date': expiry_date,
          'expiry_time': expiry_time,
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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

Future<ApiResponse> deactivateAttendance(
    int attendanceID, String? status) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse(
            '$deactivateattendanceURL/$attendanceID/deactivateAttendance'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'status': status
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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
