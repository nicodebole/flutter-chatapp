import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get(
        Uri(
            host: '192.168.0.184',
            port: 3000,
            scheme: 'http',
            path: 'api/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? '',
        },
      );

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
