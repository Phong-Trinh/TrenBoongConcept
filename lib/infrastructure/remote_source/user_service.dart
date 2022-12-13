import 'dart:convert';
import '../../domain/entity/user_entity.dart';
import '../local_source/share_preferences_service.dart';
import 'api_constant.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<UserEntity?> getUserByPhoneNumber(String phoneNumb) async {
    try {
      var url = Uri.parse(
          '${ApiConstant.baseUrl}${ApiConstant.usersEndpoint}?filters[phoneNumber][\$eq]=$phoneNumb');
      var response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        UserEntity model = praseUserFromJson(response.body);
        return model;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static Future<void> saveUserLogin(String id) async {
    try {
      await SharedPreferencesService.setUserId(id);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<UserEntity?> getUserLogedin() async {
    String? id;
    UserEntity? user;
    try {
      id = await SharedPreferencesService.getUserId();
      user = await getUserById(id!);
    } catch (e) {
      return null;
    }
    return user;
  }

  static Future<UserEntity?> getUserById(String id) async {
    try {
      var url = Uri.parse(
          '${ApiConstant.baseUrl}${ApiConstant.usersEndpoint}?filters[id][\$eq]=$id');
      var response = await http.get(url);
      print(url);
      if (response.statusCode == 200) {
        print(response.body);
        UserEntity model = praseUserFromJson(response.body);
        return model;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  static UserEntity praseUserFromJson(String json) {
    Map<String, dynamic> parsed = jsonDecode(json);
    final user = parsed['data'][0];
    return UserEntity.fromJson(user);
  }
}
