import 'package:esame_flutter_pm/ResponseLogin.dart';
/*
Questa classe serve per definire delle credenziali con un attributo in più che viene inserito dall'utente e serve per effettuare determinate richieste
 */
class FullData {
  final ResponseLogin risposta;
  final String Input;

  FullData({
    required this.risposta,
    required this.Input,
  });
}