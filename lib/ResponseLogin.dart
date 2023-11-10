import 'Utente.dart';
/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di login
 */
class ResponseLogin {
  final User utente;
  final String token;

  ResponseLogin({
    required this.utente,
    required this.token,
});

  factory ResponseLogin.fromJson(Map<String, dynamic> json) {
    return ResponseLogin(
        utente: User.fromJson(json['user']),
        token: json['token'],
    );
  }
}