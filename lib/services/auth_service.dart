import 'dart:convert';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(
        Uri(
            host: '192.168.0.184',
            port: 3000,
            scheme: 'http',
            path: 'api/login'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});

    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    }

    return false;
  }

  Future register(String name, String email, String password) async {
    autenticando = true;

    final data = {
      'nombre': name,
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      Uri(
          host: '192.168.0.184',
          port: 3000,
          scheme: 'http',
          path: 'api/login/new'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    }

    final respBody = jsonDecode(resp.body);
    return respBody['msg'];
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final resp = await http.get(
      Uri(
          host: '192.168.0.184',
          port: 3000,
          scheme: 'http',
          path: 'api/login/renew'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    }

    logout();

    return false;
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
