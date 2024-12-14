import 'dart:convert';
import 'dart:developer';
import 'package:cloudocz/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String loginUrl = 'https://erpbeta.cloudocz.com/api/auth/login';

  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      log('Login Response Status: ${response.statusCode}');
      log('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(data);
        await saveUserDetails(user);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return data['token'];
      } else {
        throw Exception('Unauthorized');
      }
    } catch (e) {
      log('Error during login: $e');
      throw Exception('Error: $e');
    }
  }

  Future<void> saveUserDetails(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDataString = jsonEncode({
      'email': user.email,
      'token': user.token,
      'name': user.name,
      'image': user.image,
      'position': user.position,
      'no_of_task': user.noOfTasks,
      'percentage': user.percentage,
    });
    await prefs.setString('userData', userDataString);
  }

  Future<UserModel> getStoredUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString != null && userDataString.isNotEmpty) {
        final data = jsonDecode(userDataString);
        return UserModel.fromJson(data);
      } else {
        throw Exception('No user data found in SharedPreferences');
      }
    } catch (e) {
      log("Error fetching stored user details: $e");
      throw Exception('Error fetching stored user details: $e');
    }
  }
}
