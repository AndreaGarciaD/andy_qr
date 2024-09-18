import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;


import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  static const String apiUrl =
      'https://front.estropical.com/resources/authentication/authenticate';

  static const String apiUrlRegister =
      'https://www.estropical.com/resources//user/estropical/estropical?welcomeEmail=false';

  Future<void> login(String username, String password) async {
    const String micrositeId = "estropical";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Access-Control-Allow-Origin": "*",
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'micrositeId': micrositeId
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];

      await storage.write(key: 'auth_token', value: token); //guardar token
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String name,
    required String surname,
    required String email,
    required String telephone,
    required String country,
    required String birthDate,
    required String documentNumber,
  }) async {
    final String? token = await _getToken();

    developer.log(token!);

    final response = await http.post(
      Uri.parse(apiUrlRegister),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'auth-token': token,
      },
      body: jsonEncode({
        'auth-token': token,
        'micrositeId': 'estropical',
        'username': username,
        'password': password,
        'name': name,
        'surname': surname,
        'email': email,
        'telephone': telephone,
        'country': country,
        'birthDate': birthDate,
        'documentNumber': documentNumber,
        'agencyId': 'estropical',
        'active': 'true',
        'newsletter': 'true',
        'b2c': 'true',
        'profile': 'USER',
        'externalCode': 'CODIGO-SAP',
      }),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode != 200) {
      developer.log(responseData.toString());
      developer.log(response.statusCode.toString());
      final String message = responseData['error'].toString();
      throw Exception(message);
    } else {
      developer.log(responseData.toString());
      developer.log(response.statusCode.toString());
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'auth_token');
  }
}
