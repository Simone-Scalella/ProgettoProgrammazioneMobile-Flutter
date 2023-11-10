import 'package:esame_flutter_pm/HomeGen/SuddLavoroGen/Lista/Commessa.dart';
/*
Questa classe rappresenta la risposta che viene data dal server dopo aver accettato la richiesta di fornire una determinata lista di suddivisioni lavoro
assegnate ad un dipendente
 */
class SuddGenResponse {
  final Commessa commessa;
  final String dipendente;
  final String valore_lavoro;
  final String quantita_assegnata;
  final String data_conclusione;

  SuddGenResponse({
    required this.commessa,
    required this.dipendente,
    required this.valore_lavoro,
    required this.quantita_assegnata,
    required this.data_conclusione,
  });

  factory SuddGenResponse.fromJson(Map<String, dynamic> json) {
    return SuddGenResponse(
      commessa: Commessa.fromJson(json['commessa']),
      dipendente: json['dipendente'],
      valore_lavoro: json['valore_lavoro'].toString(),
      quantita_assegnata: json['quantita_assegnata'].toString(),
      data_conclusione: json['data_conclusione'].toString(),
    );
  }
}