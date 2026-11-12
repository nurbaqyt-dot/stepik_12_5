import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stepik_12_5_2/models/user_model.dart';

class UserRepository {
  final http.Client httpClient;

  UserRepository({http.Client? httpClient}) : httpClient = httpClient ?? http.Client();

  Future<List<User>> fetchUsers() async {
    final response = await httpClient.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      List body = json.decode(response.body);
      return body.map((dynamic item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка при загрузке пользователей');
    }
  }
}