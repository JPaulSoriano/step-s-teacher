import 'dart:convert';
import 'package:stepteacher/constants.dart';
import 'package:stepteacher/models/response_model.dart';
import 'package:stepteacher/models/topics_model.dart';
import 'package:stepteacher/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getTopics() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(topicsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['topics']
            .map((p) => Topic.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Create topic
Future<ApiResponse> createTopic(String? name) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(createTopicURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
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
