/*
Questa classe rappresenta una parte della risposta che viene data dal server dopo aver accettato la richiesta
 */
class Commessa {
  final String codice_merce;

  Commessa({
    required this.codice_merce,
  });

  factory Commessa.fromJson(Map<String, dynamic> json) {
    return Commessa(
      codice_merce: json['codice_merce'].toString(),
    );
  }
}